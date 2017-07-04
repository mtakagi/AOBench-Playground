import Foundation
import Darwin

public struct Sphere {
    let center : Vector
    let radius : Double
    
    public init(center: Vector, radius: Double) {
        self.center = center
        self.radius = radius
    }
    
    public func rayIntersect(isect : Isect, ray : Ray) -> Isect {
        let rs = Vector(x: ray.org.x - self.center.x,
                        y: ray.org.y - self.center.y,
                        z: ray.org.z - self.center.z)
        
        
        let B = rs.dot(v : ray.dir)
        let C = rs.dot(v : rs) - self.radius * self.radius;
        let D = B * B - C
        
        if D > 0.0 {
            let t = -B - sqrt(D)
            
            if (t > 0.0) && (t < isect.t) {
                let p = Vector(x: ray.org.x + ray.dir.x * t,
                               y: ray.org.y + ray.dir.y * t,
                               z: ray.org.z + ray.dir.z * t)
                let n = Vector(x: p.x - self.center.x,
                               y: p.y - self.center.y,
                               z: p.z - self.center.z)
                return Isect(t: t, p: p, n: n.normalize(), hit: true)
            }
        }
        
        return isect
    }
}
