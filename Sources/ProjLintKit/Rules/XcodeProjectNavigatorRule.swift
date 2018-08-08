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

        violations += self.violations(for: options.structure, in: xcodeProj.pbxproj, parentPathComponents: [])
        // TODO: make sure order is like defined in structure

        if options.sorted {
            // TODO: make sure all files are sorted by name & type order
        } else {
            // TODO: make sure type order within groups is correct
        }

        return violations
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
            guard let groupChildren = children(of: currentGroup, pbxproj: pbxproj) as? [PBXGroup] else { return false }
            currentGroup = groupChildren.first { $0.path == pathComponent || $0.name == pathComponent }!
        }

        return children(of: currentGroup, pbxproj: pbxproj).contains { found in
            switch found {
            case let variantGroup as PBXVariantGroup:
                return variantGroup.path ?? variantGroup.name == pathComponents.last!

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
