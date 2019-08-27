import Difference
import Foundation
import HandySwift
import xcodeproj

struct XcodeProjectNavigatorRule: Rule {
    static let orderExceptionGroups: [String] = ["RootFiles"]

    static let name: String = "Xcode Project Navigator"
    static let identifier: String = "xcode_project_navigator"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: XcodeProjectNavigatorOptions

    init(_ optionsDict: [String: Any]) {
        options = XcodeProjectNavigatorOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        let projectUrl = URL(fileURLWithPath: options.projectPath, relativeTo: directory)
        guard let xcodeProj = try? XcodeProj(pathString: projectUrl.path) else {
            print("Could not read project file at path '\(projectUrl.path)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        // find structure violations
        violations += self.violations(for: options.structure, in: xcodeProj.pbxproj, parentPathComponents: [], projectUrl: projectUrl)

        guard let rootGroup = try? xcodeProj.pbxproj.rootGroup()! else {
            print("Could not read root group for file at path '\(projectUrl.path)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        // find inner group order violations
        violations += self.orderViolations(forChildrenIn: rootGroup, pbxproj: xcodeProj.pbxproj, parentPathComponents: [], projectUrl: projectUrl)

        // find sorted violations
        if let sortedPaths = options.sorted {
            for sortedPath in sortedPaths {
                // swiftlint:disable:next remove_where_for_negative_filtering
                let parentPathComponents = sortedPath.components(separatedBy: "/").filter { !$0.isBlank }
                violations += self.sortedViolations(pbxproj: xcodeProj.pbxproj, parentPathComponents: parentPathComponents, projectUrl: projectUrl)
            }
        }

        return violations
    }

    private func sortedViolations(pbxproj: PBXProj, parentPathComponents: [String], projectUrl: URL) -> [Violation] {
        var violations = [Violation]()
        var currentGroup: PBXGroup = try! pbxproj.rootGroup()! // swiftlint:disable:this force_try

        for pathComponent in parentPathComponents {
            let groupChildren = currentGroup.groupChildren
            guard let newGroup = groupChildren.first(where: { $0.path == pathComponent || $0.name == pathComponent }) else {
                let path = parentPathComponents.joined(separator: "/")
                print("Could not find group at path '\(path)' for sort validation in project '\(projectUrl.path)'.", level: .error)
                exit(EXIT_FAILURE)
            }

            currentGroup = newGroup
        }

        let children = currentGroup.children

        for expectedGroupTypes in options.innerGroupOrder {
            let childrenOfGroupTypes = children.filter { expectedGroupTypes.contains(groupType(for: $0)) }
            let childrenNames = childrenOfGroupTypes.map { name(for: $0) }
            let sortedChildrenNames = childrenNames.sorted()

            if sortedChildrenNames != childrenNames {
                let expected = expectedGroupTypes.map { $0.rawValue }.joined(separator: ",")
                let parentPath = parentPathComponents.joined(separator: "/")

                let difference = diff(sortedChildrenNames, childrenNames)

                let message = """
                    Entries of type(s) '\(expected)' in group '\(parentPath)' are not sorted by name.
                    Found:\n\(childrenNames)
                    Expected:\n\(sortedChildrenNames)
                    Difference:\n\(difference.joined())
                    """
                violations.append(
                    FileViolation(
                        rule: self,
                        message: message,
                        level: defaultViolationLevel,
                        url: projectUrl
                    )
                )
            }
        }

        for group in currentGroup.groupChildren {
            violations += self.sortedViolations(pbxproj: pbxproj, parentPathComponents: parentPathComponents + [name(for: group)], projectUrl: projectUrl)
        }

        return violations
    }

    private func orderViolations(forChildrenIn group: PBXGroup, pbxproj: PBXProj, parentPathComponents: [String], projectUrl: URL) -> [Violation] {
        guard group.name == nil || !XcodeProjectNavigatorRule.orderExceptionGroups.contains(group.name!) else { return [] }

        var violations = [Violation]()
        let children = group.children

        var lastMatchingIndex = -1
        for expectedGroupTypes in options.innerGroupOrder {
            var potentialViolatingIndexes = [Int]()

            let startIndex = lastMatchingIndex + 1
            for index in (startIndex ..< children.count) {
                let groupType = self.groupType(for: children[index])
                if expectedGroupTypes.contains(groupType) {
                    lastMatchingIndex = index
                } else {
                    potentialViolatingIndexes.append(index)
                }
            }

            let violatingIndexes = potentialViolatingIndexes.filter { $0 < lastMatchingIndex }
            for violatingIndex in violatingIndexes {
                let groupType = self.groupType(for: children[violatingIndex]).rawValue
                let expected = expectedGroupTypes.map { $0.rawValue }.joined(separator: ",")
                let name = self.name(for: children[violatingIndex])
                let path = (parentPathComponents + [name]).joined(separator: "/")

                violations.append(
                    FileViolation(
                        rule: self,
                        message: "The '\(groupType)' entry '\(path)' should not be placed amongst the group type(s) '\(expected)'.",
                        level: defaultViolationLevel,
                        url: projectUrl
                    )
                )
            }
        }

        for group in group.groupChildren {
            violations += self.orderViolations(
                forChildrenIn: group,
                pbxproj: pbxproj,
                parentPathComponents: parentPathComponents + [name(for: group)],
                projectUrl: projectUrl
            )
        }

        return violations
    }

    private func name(for element: Any) -> String {
        switch element {
        case let group as PBXGroup:
            return group.path ?? group.name!

        case let fileElement as PBXFileElement:
            return fileElement.path ?? fileElement.name!

        default:
            print("Found unexpected type in project group children.", level: .error)
            exit(EXIT_FAILURE)
        }
    }

    private func groupType(for element: Any) -> XcodeProjectNavigatorOptions.GroupType {
        if element is PBXGroup && !(element is PBXVariantGroup) {
            return .folder
        }

        let name = self.name(for: element)

        if name == "beak.swift" {
            return .other
        }

        if name.hasSuffix(".swift") || name.hasSuffix(".h") || name.hasSuffix(".m") || name.hasSuffix(".mm") {
            return .codeFile
        }

        if name.hasSuffix(".storyboard") || name.hasSuffix(".xib") {
            return .interface
        }

        if name.hasSuffix(".xcassets") {
            return .assets
        }

        if name.hasSuffix(".strings") || name.hasSuffix(".stringsdict") {
            return .strings
        }

        if name.hasSuffix(".entitlements") {
            return .entitlement
        }

        if name.hasSuffix(".plist") {
            return .plist
        }

        return .other
    }

//    private func groupChildren(of group: PBXGroup, pbxproj: PBXProj) -> [PBXGroup] {
//        return children(of: group, pbxproj: pbxproj).filter { !($0 is PBXVariantGroup) }.compactMap { $0 as? PBXGroup }
//    }
//
//    private func children(of group: PBXGroup, pbxproj: PBXProj) -> [Any] {
//        let groups = pbxproj.groups
//        let variantGroups = pbxproj.variantGroups
//        let filesReferences = pbxproj.fileReferences
//        return group.children.compactMap { groups[$0] ?? variantGroups[$0] ?? filesReferences[$0] }
//    }

    private func violations(
        for substructure: [XcodeProjectNavigatorOptions.TreeNode],
        in pbxproj: PBXProj,
        parentPathComponents: [String],
        projectUrl: URL
        ) -> [Violation] {
        var violations = [Violation]()

        for node in substructure {
            switch node {
            case let .leaf(fileName):
                if !entryExists(at: parentPathComponents + [fileName], in: pbxproj) {
                    let parentPath = parentPathComponents.isEmpty ? "root" : parentPathComponents.joined(separator: "/")
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected to find entry '\(fileName)' in path '\(parentPath)' within the project navigator.",
                            level: defaultViolationLevel,
                            url: projectUrl
                        )
                    )
                }

            case let .subtree(groupName, subnodes):
                if !entryExists(at: parentPathComponents + [groupName], in: pbxproj) {
                    let parentPath = parentPathComponents.isEmpty ? "root" : parentPathComponents.joined(separator: "/")
                    violations.append(
                        FileViolation(
                            rule: self,
                            message: "Expected to find entry '\(groupName)' in path '\(parentPath)' within the project navigator.",
                            level: defaultViolationLevel,
                            url: projectUrl
                        )
                    )
                } else {
                    violations += self.violations(for: subnodes, in: pbxproj, parentPathComponents: parentPathComponents + [groupName], projectUrl: projectUrl)
                }
            }
        }

        // TODO: also make sure the given order within the structure is correct

        return violations
    }

    private func entryExists(at pathComponents: [String], in pbxproj: PBXProj) -> Bool {
        var currentGroup: PBXGroup = try! pbxproj.rootGroup()! // swiftlint:disable:this force_try

        for pathComponent in pathComponents.dropLast() {
            let groupChildren = currentGroup.groupChildren
            currentGroup = groupChildren.first { $0.path == pathComponent || $0.name == pathComponent }!
        }

        return currentGroup.children.contains { found in
            switch found {
            case let group as PBXGroup:
                return group.path ?? group.name == pathComponents.last!

            default:
                return found.path ?? found.name == pathComponents.last!
            }
        }
    }

    private func childrenAreOrdered(order orderedChildren: [String], inGroup groupPathComponents: [String], pbxproj: PBXProj) -> Bool {
        // TODO: not yet implemented
        return true
    }
}
