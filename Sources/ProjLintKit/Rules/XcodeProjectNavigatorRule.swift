import Foundation
import HandySwift
import xcodeproj

struct XcodeProjectNavigatorRule: Rule {
    static let name: String = "Xcode Project Navigator"
    static let identifier: String = "xcode_project_navigator"

    private let defaultViolationLevel: ViolationLevel = .warning
    private let options: XcodeProjectNavigatorOptions

    init(_ optionsDict: [String: Any]) {
        options = XcodeProjectNavigatorOptions(optionsDict, rule: type(of: self))
    }

    func violations(in directory: URL) -> [Violation] {
        var violations = [Violation]()

        let absolutePathUrl = URL(fileURLWithPath: options.projectPath)
        guard let xcodeProj = try? XcodeProj(pathString: absolutePathUrl.path) else {
            print("Could not read project file at path '\(absolutePathUrl.path)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        // find structure violations
        violations += self.violations(for: options.structure, in: xcodeProj.pbxproj, parentPathComponents: [])

        guard let rootGroup = try? xcodeProj.pbxproj.rootGroup()! else {
            print("Could not read root group for file at path '\(absolutePathUrl.path)'.", level: .error)
            exit(EXIT_FAILURE)
        }

        // find group content order & sorting violations
        violations += self.orderViolations(forChildrenIn: rootGroup, pbxproj: xcodeProj.pbxproj, parentPathComponents: [])

        return violations
    }

    private func orderViolations(forChildrenIn group: PBXGroup, pbxproj: PBXProj, parentPathComponents: [String]) -> [Violation] {
        var violations = [Violation]()
        let children = self.children(of: group, pbxproj: pbxproj)

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
                        path: options.projectPath
                    )
                )
            }
        }

        let groupChildren = self.groupChildren(of: group, pbxproj: pbxproj)
        for group in groupChildren {
            violations += self.orderViolations(forChildrenIn: group, pbxproj: pbxproj, parentPathComponents: parentPathComponents + [name(for: group)])
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

    private func groupChildren(of group: PBXGroup, pbxproj: PBXProj) -> [PBXGroup] {
        return children(of: group, pbxproj: pbxproj).filter { !($0 is PBXVariantGroup) }.compactMap { $0 as? PBXGroup }
    }

    private func children(of group: PBXGroup, pbxproj: PBXProj) -> [Any] {
        let groups = pbxproj.objects.groups
        let variantGroups = pbxproj.objects.variantGroups
        let filesReferences = pbxproj.objects.fileReferences
        return group.childrenReferences.compactMap { groups[$0] ?? variantGroups[$0] ?? filesReferences[$0] }
    }

    private func violations(for substructure: [XcodeProjectNavigatorOptions.TreeNode], in pbxproj: PBXProj, parentPathComponents: [String]) -> [Violation] {
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
                            path: options.projectPath
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
                            path: options.projectPath
                        )
                    )
                } else {
                    violations += self.violations(for: subnodes, in: pbxproj, parentPathComponents: parentPathComponents + [groupName])
                }
            }
        }

        return violations
    }

    private func entryExists(at pathComponents: [String], in pbxproj: PBXProj) -> Bool {
        var currentGroup: PBXGroup = try! pbxproj.rootGroup()!

        for pathComponent in pathComponents.dropLast() {
            let groupChildren = self.groupChildren(of: currentGroup, pbxproj: pbxproj)
            currentGroup = groupChildren.first { $0.path == pathComponent || $0.name == pathComponent }!
        }

        return children(of: currentGroup, pbxproj: pbxproj).contains { found in
            switch found {
            case let group as PBXGroup:
                return group.path ?? group.name == pathComponents.last!

            case let fileElement as PBXFileElement:
                return fileElement.path ?? fileElement.name == pathComponents.last!

            default:
                print("Found unexpected type in project group children.", level: .error)
                exit(EXIT_FAILURE)
            }
        }
    }

    private func childrenAreOrdered(order orderedChildren: [String], inGroup groupPathComponents: [String], pbxproj: PBXProj) -> Bool {
        // TODO: not yet implemented
        return true
    }
}
