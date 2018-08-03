// beak: kareman/SwiftShell @ .upToNextMajor(from: "4.0.1")

import Foundation
import SwiftShell

public func generateLinuxMain() {
    run(bash: "sourcery --sources Tests --templates .sourcery/LinuxMain.stencil --output .sourcery --force-parse generated")
    run(bash: "mv .sourcery/LinuxMain.generated.swift Tests/LinuxMain.swift")
}
