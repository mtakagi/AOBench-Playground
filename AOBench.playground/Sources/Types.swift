import Foundation

public struct Isect {
    public let t : Double
    public let p : Vector
    public let n : Vector
    public let hit : Bool
    
    public init(t: Double, p: Vector, n: Vector, hit: Bool) {
        self.t = t
        self.p = p
        self.n = n
        self.hit = hit
    }
}

public struct Ray {
    public let org : Vector
    public let dir : Vector
    
    public init(org: Vector, dir: Vector) {
        self.org = org
        self.dir = dir
    }
}

public extension Double {
    
    public func clamp() -> UInt8 {
        switch Int32(self * 255.5) {
        case let i where i < 0:
            return 0
        case let i where i > 255:
            return 255
        default:
            return UInt8(self * 255.5)
        }
    }
    
}
