import Foundation
import Darwin

public struct Plane {
    let p : Vector
    let n : Vector
    
    public init(p: Vector, n: Vector) {
        self.p = p
        self.n = n
    }
    
    public func rayIntersect(isect : Isect, ray : Ray) -> Isect
    {
        let d = -self.p.dot(v : self.n);
        let v = ray.dir.dot(v : self.n);
        
        if fabs(v) < 1.0e-17 {
            return isect
        }
        
        let t = -(ray.org.dot(v : self.n) + d) / v;
        
        if (t > 0.0) && (t < isect.t) {
            let p = Vector(x: ray.org.x + ray.dir.x * t,
                           y: ray.org.y + ray.dir.y * t,
                           z: ray.org.z + ray.dir.z * t)
            
            return Isect(t: t, p: p, n: self.n, hit: true)
        }
        
        return isect
    }
}
