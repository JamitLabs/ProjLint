import Foundation
import xcodeproj

extension PBXGroup {
    var groupChildren: [PBXGroup] {
        return children.filter { $0 is PBXGroup && !($0 is PBXVariantGroup) } as! [PBXGroup]
    }
}
