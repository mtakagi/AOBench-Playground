import Foundation

public struct Vector {
    public let x : Double
    public let y : Double
    public let z : Double
    
    public init(x: Double, y: Double, z: Double) {
        self.x = x
        self.y = y
        self.z = z
    }
    
    public static let zero = Vector(x : 0.0, y: 0.0, z: 0.0)
    
    public func dot(v : Vector) -> Double {
        return self.x * v.x + self.y * v.y + self.z * v.z
    }
    
    public func cross(v : Vector) -> Vector {
        return Vector(x: self.y * v.z - self.z * v.y,
                      y: self.z * v.x - self.x * v.z,
                      z: self.x * v.y - self.y * v.x)
    }
    
    public func length() -> Double {
        return sqrt(self.dot(v: self))
    }
    
    public func normalize() -> Vector {
        let length = self.length()
        
        if fabs(length) > 1.0e-17 {
            return Vector(x: self.x / length,
                          y: self.y / length,
                          z: self.z / length)
        }
        
        return self
    }
}

extension Vector : Equatable {
}

public func -(lhs : Vector, rhs : Vector) -> Vector {
    return Vector(x: lhs.x - rhs.x, y: lhs.y - rhs.y, z: lhs.z - rhs.z)
}

public func -(lhs : Vector, rhs : Double) -> Vector {
    return Vector(x: lhs.x - rhs, y: lhs.y - rhs, z: lhs.z - rhs)
}

public func +(lhs : Vector, rhs : Vector) -> Vector {
    return Vector(x: lhs.x + rhs.x, y: lhs.y + rhs.y, z: lhs.z + rhs.z)
}

public func +(lhs : Vector, rhs : Double) -> Vector {
    return Vector(x: lhs.x + rhs, y: lhs.y + rhs, z: lhs.z + rhs)
}

public func *(lhs : Vector, rhs : Vector) -> Vector {
    return Vector(x: lhs.x * rhs.x, y: lhs.y * rhs.y, z: lhs.z * rhs.z)
}

public func *(lhs : Vector, rhs : Double) -> Vector {
    return Vector(x: lhs.x * rhs, y: lhs.y * rhs, z: lhs.z * rhs)
}

public func ==(lhs : Vector, rhs : Vector) -> Bool {
    return lhs.x == rhs.x && lhs.y == rhs.y && lhs.z == rhs.z
}

extension Vector {
    public typealias Basis = [Vector]
    
    public func orthoBasis() -> Basis {
        var basis = Basis(repeating: Vector.zero, count : 3)
        basis[2] = self;
        
        switch (self.x, self.y, self.z) {
        case (let x, _, _) where x < 0.6 && x > -0.6:
            basis[1] = Vector(x : 1.0, y: 0.0, z: 0.0)
        case (_, let y, _) where y < 0.6 && y > -0.6:
            basis[1] = Vector(x : 0.0, y: 1.0, z: 0.0)
        case (_, _, let z) where z < 0.6 && z > -0.6:
            basis[1] = Vector(x : 0.0, y: 0.0, z: 1.0)
        default:
            basis[1] = Vector(x : 1.0, y: 0.0, z: 0.0)
        }
        
        basis[0] = basis[1].cross(v: basis[2]).normalize()
        basis[1] = basis[2].cross(v: basis[0]).normalize()
        
        return basis
    }
}
