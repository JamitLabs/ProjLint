@testable import ProjLintKit
import XCTest

// swiftlint:disable type_body_length line_length

final class XcodeBuildPhasesRuleTests: XCTestCase {
    private static let xcprojPath: String = "Example.xcodeproj"
    let xcprojResource = Resource(
        path: "\(xcprojPath)/project.pbxproj",
        contents: """
            // !$*UTF8*$!
            {
            	archiveVersion = 1;
            	classes = {
            	};
            	objectVersion = 46;
            	objects = {

            /* Begin PBXBuildFile section */
            		OBJ_22 /* Test.swift in Sources */ = {isa = PBXBuildFile; fileRef = OBJ_9 /* Test.swift */; };
            /* End PBXBuildFile section */

            /* Begin PBXFileReference section */
            		OBJ_9 /* Test.swift */ = {isa = PBXFileReference; lastKnownFileType = sourcecode.swift; path = Test.swift; sourceTree = "<group>"; };
            		"Test::Test::Product" /* Test.framework */ = {isa = PBXFileReference; explicitFileType = wrapper.framework; name = Test.framework; path = /Users/Arbeit/Desktop/Test/build/Debug/Test.framework; sourceTree = "<absolute>"; };
            /* End PBXFileReference section */

            /* Begin PBXFrameworksBuildPhase section */
            		OBJ_23 /* Frameworks */ = {
            			isa = PBXFrameworksBuildPhase;
            			buildActionMask = 0;
            			files = (
            			);
            			runOnlyForDeploymentPostprocessing = 0;
            		};
            /* End PBXFrameworksBuildPhase section */

            /* Begin PBXGroup section */
            		OBJ_5 = {
            			isa = PBXGroup;
            			children = (
            				OBJ_7 /* Sources */,
            			);
            			sourceTree = "<group>";
            		};
            		OBJ_7 /* Sources */ = {
            			isa = PBXGroup;
            			children = (
            				OBJ_8 /* Test */,
            			);
            			name = Sources;
            			sourceTree = SOURCE_ROOT;
            		};
            		OBJ_8 /* Test */ = {
            			isa = PBXGroup;
            			children = (
            				OBJ_9 /* Test.swift */,
            			);
            			name = Test;
            			path = Sources/Test;
            			sourceTree = SOURCE_ROOT;
            		};
            /* End PBXGroup section */

            /* Begin PBXNativeTarget section */
            		"Test::Test" /* Test */ = {
            			isa = PBXNativeTarget;
            			buildConfigurationList = OBJ_18 /* Build configuration list for PBXNativeTarget "Test" */;
            			buildPhases = (
            				OBJ_21 /* Sources */,
            				OBJ_23 /* Frameworks */,
            				8218959A211B281700CF5073 /* SwiftLint */,
            			);
            			buildRules = (
            			);
            			dependencies = (
            			);
            			name = Test;
            			productName = Test;
            			productReference = "Test::Test::Product" /* Test.framework */;
            			productType = "com.apple.product-type.framework";
            		};
            /* End PBXNativeTarget section */

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
            				"Test::Test" /* Test */,
            			);
            		};
            /* End PBXProject section */

            /* Begin PBXShellScriptBuildPhase section */
            		8218959A211B281700CF5073 /* SwiftLint */ = {
            			isa = PBXShellScriptBuildPhase;
            			buildActionMask = 2147483647;
            			files = (
            			);
            			inputPaths = (
            			);
            			name = SwiftLint;
            			outputPaths = (
            			);
            			runOnlyForDeploymentPostprocessing = 0;
            			shellPath = /bin/sh;
            			shellScript = "if which swiftlint > /dev/null; then\n    swiftlint\nelse\n    echo \"warning: SwiftLint not installed, download it from https://github.com/realm/SwiftLint\"\nfi";
            		};
            /* End PBXShellScriptBuildPhase section */

            /* Begin PBXSourcesBuildPhase section */
            		OBJ_21 /* Sources */ = {
            			isa = PBXSourcesBuildPhase;
            			buildActionMask = 0;
            			files = (
            				OBJ_22 /* Test.swift in Sources */,
            			);
            			runOnlyForDeploymentPostprocessing = 0;
            		};
            /* End PBXSourcesBuildPhase section */

            /* Begin XCBuildConfiguration section */
            		OBJ_19 /* Debug */ = {
            			isa = XCBuildConfiguration;
            			buildSettings = {
            				ENABLE_TESTABILITY = YES;
            				FRAMEWORK_SEARCH_PATHS = (
            					"$(inherited)",
            					"$(PLATFORM_DIR)/Developer/Library/Frameworks",
            				);
            				HEADER_SEARCH_PATHS = "$(inherited)";
            				INFOPLIST_FILE = Test.xcodeproj/Test_Info.plist;
            				LD_RUNPATH_SEARCH_PATHS = "$(inherited) $(TOOLCHAIN_DIR)/usr/lib/swift/macosx";
            				OTHER_CFLAGS = "$(inherited)";
            				OTHER_LDFLAGS = "$(inherited)";
            				OTHER_SWIFT_FLAGS = "$(inherited)";
            				PRODUCT_BUNDLE_IDENTIFIER = Test;
            				PRODUCT_MODULE_NAME = "$(TARGET_NAME:c99extidentifier)";
            				PRODUCT_NAME = "$(TARGET_NAME:c99extidentifier)";
            				SKIP_INSTALL = YES;
            				SWIFT_VERSION = 4.0;
            				TARGET_NAME = Test;
            			};
            			name = Debug;
            		};
            		OBJ_20 /* Release */ = {
            			isa = XCBuildConfiguration;
            			buildSettings = {
            				ENABLE_TESTABILITY = YES;
            				FRAMEWORK_SEARCH_PATHS = (
            					"$(inherited)",
            					"$(PLATFORM_DIR)/Developer/Library/Frameworks",
            				);
            				HEADER_SEARCH_PATHS = "$(inherited)";
            				INFOPLIST_FILE = Test.xcodeproj/Test_Info.plist;
            				LD_RUNPATH_SEARCH_PATHS = "$(inherited) $(TOOLCHAIN_DIR)/usr/lib/swift/macosx";
            				OTHER_CFLAGS = "$(inherited)";
            				OTHER_LDFLAGS = "$(inherited)";
            				OTHER_SWIFT_FLAGS = "$(inherited)";
            				PRODUCT_BUNDLE_IDENTIFIER = Test;
            				PRODUCT_MODULE_NAME = "$(TARGET_NAME:c99extidentifier)";
            				PRODUCT_NAME = "$(TARGET_NAME:c99extidentifier)";
            				SKIP_INSTALL = YES;
            				SWIFT_VERSION = 4.0;
            				TARGET_NAME = Test;
            			};
            			name = Release;
            		};
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
            		OBJ_18 /* Build configuration list for PBXNativeTarget "Test" */ = {
            			isa = XCConfigurationList;
            			buildConfigurations = (
            				OBJ_19 /* Debug */,
            				OBJ_20 /* Release */,
            			);
            			defaultConfigurationIsVisible = 0;
            			defaultConfigurationName = Release;
            		};
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

    func testAllOptions() {
        resourcesLoaded([xcprojResource]) {
            let optionsDict: [String: Any] = [
                "project_path": XcodeBuildPhasesRuleTests.xcprojPath,
                "target_name": "Test",
                "run_scripts": [
                    "SwiftLint": """
                        if which swiftlint > /dev/null; then
                            swiftlint
                        else
                            echo "warning: SwiftLint not installed, download it from https://github.com/realm/SwiftLint"
                        fi

                        """
                ]
            ]
            // TODO: re-enable once https://github.com/tuist/xcodeproj/issues/280 is solved
//            let rule = XcodeBuildPhasesRule(optionsDict)
//
//            let violations = rule.violations(in: Resource.baseUrl)
//            XCTAssertEqual(violations.count, 0)
        }

        resourcesLoaded([xcprojResource]) {
            let optionsDict: [String: Any] = [
                "project_path": XcodeBuildPhasesRuleTests.xcprojPath,
                "target_name": "Test",
                "run_scripts": [
                    "ProjLint": """
                        if which projlint > /dev/null; then
                            projlint lint
                        else
                            echo "warning: ProjLint not installed, download it from https://github.com/JamitLabs/ProjLint"
                        fi

                        """
                ]
            ]
            // TODO: re-enable once https://github.com/tuist/xcodeproj/issues/280 is solved
//            let rule = XcodeBuildPhasesRule(optionsDict)
//
//            let violations = rule.violations(in: Resource.baseUrl)
//            XCTAssertEqual(violations.count, 1)
        }
    }
}
