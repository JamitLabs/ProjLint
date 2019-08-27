@testable import ProjLintKit
import XCTest

// swiftlint:disable type_body_length line_length multiline_literal_brackets function_body_length

final class XcodeProjectNavigatorRuleTests: XCTestCase {
    private static let xcprojPath: String = "Example.xcodeproj"
    let xcprojResource = Resource(
        path: "\(XcodeProjectNavigatorRuleTests.xcprojPath)/project.pbxproj",
        contents: """
            // !$*UTF8*$!
            {
                archiveVersion = 1;
                classes = {
                };
                objectVersion = 46;
                objects = {

            /* Begin PBXFileReference section */
                    82189633211B47A600CF5073 /* TestB.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TestB.swift; sourceTree = "<group>"; };
                    82EA08BF211B47F1009CECE0 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
                    82EA08C1211B4811009CECE0 /* Info.plist */ = {isa = PBXFileReference; lastKnownFileType = text.plist.xml; path = Info.plist; sourceTree = "<group>"; };
                    82EA08C2211B4821009CECE0 /* LaunchScreen.storyboard */ = {isa = PBXFileReference; lastKnownFileType = file.storyboard; path = LaunchScreen.storyboard; sourceTree = "<group>"; };
                    82EA08C3211B483C009CECE0 /* TestA.xib */ = {isa = PBXFileReference; lastKnownFileType = file.xib; path = TestA.xib; sourceTree = "<group>"; };
                    82EA08C4211B4844009CECE0 /* TestB.xib */ = {isa = PBXFileReference; lastKnownFileType = file.xib; path = TestB.xib; sourceTree = "<group>"; };
                    82EA08C5211B4857009CECE0 /* Localizable.strings */ = {isa = PBXFileReference; lastKnownFileType = text.plist.strings; path = Localizable.strings; sourceTree = "<group>"; };
                    82EA08C6211B48B7009CECE0 /* AppDelegate.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = AppDelegate.swift; sourceTree = "<group>"; };
                    82EA08C7211B4A82009CECE0 /* XyzController.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = XyzController.swift; sourceTree = "<group>"; };
                    OBJ_12 /* TestTests.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TestTests.swift; sourceTree = "<group>"; };
                    OBJ_13 /* XCTestManifests.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = XCTestManifests.swift; sourceTree = "<group>"; };
                    OBJ_6 /* Package.swift */ = {isa = PBXFileReference; explicitFileType = sourcecode.swift; path = Package.swift; sourceTree = "<group>"; };
                    OBJ_9 /* TestA.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = TestA.swift; sourceTree = "<group>"; };
            /* End PBXFileReference section */

            /* Begin PBXGroup section */
                    82189635211B47B500CF5073 /* SupportingFiles */ = {
                        isa = PBXGroup;
                        children = (
                            82EA08BF211B47F1009CECE0 /* Info.plist */,
                        );
                        path = SupportingFiles;
                        sourceTree = "<group>";
                    };
                    82EA08C0211B47FE009CECE0 /* SupportingFiles */ = {
                        isa = PBXGroup;
                        children = (
                            82EA08C1211B4811009CECE0 /* Info.plist */,
                            82EA08C2211B4821009CECE0 /* LaunchScreen.storyboard */,
                            82EA08C5211B4857009CECE0 /* Localizable.strings */,
                        );
                        name = SupportingFiles;
                        path = SupportingFiels;
                        sourceTree = "<group>";
                    };
                    OBJ_10 /* Tests */ = {
                        isa = PBXGroup;
                        children = (
                            OBJ_11 /* Sources */,
                            82189635211B47B500CF5073 /* SupportingFiles */,
                        );
                        name = Tests;
                        sourceTree = SOURCE_ROOT;
                    };
                    OBJ_11 /* Sources */ = {
                        isa = PBXGroup;
                        children = (
                            OBJ_12 /* TestTests.swift */,
                            OBJ_13 /* XCTestManifests.swift */,
                        );
                        name = Sources;
                        path = Tests/Sources;
                        sourceTree = SOURCE_ROOT;
                    };
                    OBJ_5 = {
                        isa = PBXGroup;
                        children = (
                            OBJ_6 /* Package.swift */,
                            OBJ_7 /* App */,
                            OBJ_10 /* Tests */,
                        );
                        sourceTree = "<group>";
                    };
                    OBJ_7 /* App */ = {
                        isa = PBXGroup;
                        children = (
                            82EA08C6211B48B7009CECE0 /* AppDelegate.swift */,
                            OBJ_8 /* Sources */,
                            82EA08C0211B47FE009CECE0 /* SupportingFiles */,
                        );
                        name = App;
                        sourceTree = SOURCE_ROOT;
                    };
                    OBJ_8 /* Sources */ = {
                        isa = PBXGroup;
                        children = (
                            OBJ_9 /* TestA.swift */,
                            82189633211B47A600CF5073 /* TestB.swift */,
                            82EA08C3211B483C009CECE0 /* TestA.xib */,
                            82EA08C4211B4844009CECE0 /* TestB.xib */,
                            82EA08C7211B4A82009CECE0 /* XyzController.swift */,
                        );
                        name = Sources;
                        path = Sources/Sources;
                        sourceTree = SOURCE_ROOT;
                    };
            /* End PBXGroup section */

            /* Begin PBXProject section */
                    OBJ_1 /* Project object */ = {
                        isa = PBXProject;
                        attributes = {
                            LastUpgradeCheck = 9999;
                        };
                        buildConfigurationList = OBJ_2 /* Build configuration list for PBXProject "Test" */;
                        compatibilityVersion = "Xcode 3.2";
                        developmentRegion = English;
                        hasScannedForEncodings = 0;
                        knownRegions = (
                            en,
                        );
                        mainGroup = OBJ_5;
                        productRefGroup = OBJ_5;
                        projectDirPath = "";
                        projectRoot = "";
                        targets = (
                        );
                    };
            /* End PBXProject section */

            /* Begin XCBuildConfiguration section */
                    OBJ_3 /* Debug */ = {
                        isa = XCBuildConfiguration;
                        buildSettings = {
                            CLANG_ENABLE_OBJC_ARC = YES;
                            COMBINE_HIDPI_IMAGES = YES;
                            COPY_PHASE_STRIP = NO;
                            DEBUG_INFORMATION_FORMAT = dwarf;
                            DYLIB_INSTALL_NAME_BASE = "@rpath";
                            ENABLE_NS_ASSERTIONS = YES;
                            GCC_OPTIMIZATION_LEVEL = 0;
                            MACOSX_DEPLOYMENT_TARGET = 10.10;
                            ONLY_ACTIVE_ARCH = YES;
                            OTHER_SWIFT_FLAGS = "-DXcode";
                            PRODUCT_NAME = "$(TARGET_NAME)";
                            SDKROOT = macosx;
                            SUPPORTED_PLATFORMS = "macosx iphoneos iphonesimulator appletvos appletvsimulator watchos watchsimulator";
                            SWIFT_ACTIVE_COMPILATION_CONDITIONS = SWIFT_PACKAGE;
                            SWIFT_OPTIMIZATION_LEVEL = "-Onone";
                            USE_HEADERMAP = NO;
                        };
                        name = Debug;
                    };
                    OBJ_4 /* Release */ = {
                        isa = XCBuildConfiguration;
                        buildSettings = {
                            CLANG_ENABLE_OBJC_ARC = YES;
                            COMBINE_HIDPI_IMAGES = YES;
                            COPY_PHASE_STRIP = YES;
                            DEBUG_INFORMATION_FORMAT = "dwarf-with-dsym";
                            DYLIB_INSTALL_NAME_BASE = "@rpath";
                            GCC_OPTIMIZATION_LEVEL = s;
                            MACOSX_DEPLOYMENT_TARGET = 10.10;
                            OTHER_SWIFT_FLAGS = "-DXcode";
                            PRODUCT_NAME = "$(TARGET_NAME)";
                            SDKROOT = macosx;
                            SUPPORTED_PLATFORMS = "macosx iphoneos iphonesimulator appletvos appletvsimulator watchos watchsimulator";
                            SWIFT_ACTIVE_COMPILATION_CONDITIONS = SWIFT_PACKAGE;
                            SWIFT_OPTIMIZATION_LEVEL = "-Owholemodule";
                            USE_HEADERMAP = NO;
                        };
                        name = Release;
                    };
            /* End XCBuildConfiguration section */

            /* Begin XCConfigurationList section */
                    OBJ_2 /* Build configuration list for PBXProject "Test" */ = {
                        isa = XCConfigurationList;
                        buildConfigurations = (
                            OBJ_3 /* Debug */,
                            OBJ_4 /* Release */,
                        );
                        defaultConfigurationIsVisible = 0;
                        defaultConfigurationName = Release;
                    };
            /* End XCConfigurationList section */
                };
                rootObject = OBJ_1 /* Project object */;
            }
            """
    )

    func testWithAllOptions() {
        resourcesLoaded([xcprojResource]) {
            let optionsDict: [String: Any] = [
                "project_path": XcodeProjectNavigatorRuleTests.xcprojPath,
                "sorted": [],
                "inner_group_order": [
                    ["others", "plists", "entitlements"],
                    ["code_files", "interfaces"],
                    "assets",
                    ["strings", "folders"]
                ],
                "structure": [
                    "Package.swift",
                    ["App": [
                        "AppDelegate.swift"
                    ]],
                    ["Tests": [
                        ["SupportingFiles": [
                            "Info.plist"
                        ]]
                    ]]
                ]
            ]
            let rule = XcodeProjectNavigatorRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([xcprojResource]) {
            let optionsDict: [String: Any] = [
                "project_path": XcodeProjectNavigatorRuleTests.xcprojPath,
                "sorted": [
                    "App",
                    "Tests"
                ],
                "inner_group_order": [
                    ["interfaces", "code_files"],
                    "assets",
                    ["strings", "others"],
                    "folders"
                ],
                "structure": [
                    "Package.swift",
                    ["App": [
                        "AppDelegate.swift",
                        "Resources"
                    ]],
                    ["Tests": [
                        ["SupportingFiles": [
                            "Info.plist"
                        ]]
                    ]],
                    ["UITests": [
                        ["SupportingFiles": [
                            "Info.plist"
                        ]]
                    ]]
                ]
            ]
            let rule = XcodeProjectNavigatorRule(optionsDict)

            let violations = rule.violations(in: Resource.baseUrl)
            XCTAssertEqual(violations.count, 5)
        }
    }
}
