import Foundation

let NAOSamples = 8

let spheres = [
    Sphere(center: Vector(x: -2.0, y: 0.0, z: -3.5),
           radius: 0.5),
    Sphere(center: Vector(x: -0.5, y: 0.0, z: -3.0),
           radius: 0.5),
    Sphere(center: Vector(x: 1.0, y: 0.0, z: -2.2),
           radius: 0.5)
]
let plane = Plane(p: Vector(x: 0.0, y: -0.5, z: 0.0),
                  n: Vector(x: 0.0, y: 1.0 , z: 0.0))

func ambient_occlusion(isect : Isect) -> Vector
{
    let ntheta : Int = NAOSamples
    let nphi : Int = NAOSamples
    let eps : Double = 0.0001
    
    let p = Vector(x: isect.p.x + eps * isect.n.x,
                   y: isect.p.y + eps * isect.n.y,
                   z: isect.p.z + eps * isect.n.z)
    
    let basis = isect.n.orthoBasis()
    var occlusion : Double = 0.0;
    
    for _ in 0..<ntheta {
        for _ in 0..<nphi {
            let theta = sqrt(drand48());
            let phi = 2.0 * Double.pi * drand48();
            
            let x = cos(phi) * theta;
            let y = sin(phi) * theta;
            let z = sqrt(1.0 - theta * theta);
            
            // local . global
            let rx = x * basis[0].x + y * basis[1].x + z * basis[2].x;
            let ry = x * basis[0].y + y * basis[1].y + z * basis[2].y;
            let rz = x * basis[0].z + y * basis[1].z + z * basis[2].z;
            
            let ray = Ray(org: p, dir: Vector(x: rx, y: ry, z: rz))
            var occIsect = Isect(t: 1.0e+17, p: Vector.zero, n: Vector.zero, hit: false)
            
            occIsect = spheres[0].rayIntersect(isect: occIsect, ray: ray)
            occIsect = spheres[1].rayIntersect(isect: occIsect, ray: ray)
            occIsect = spheres[2].rayIntersect(isect: occIsect, ray: ray)
            occIsect = plane.rayIntersect(isect: occIsect, ray: ray)
            
            if occIsect.hit {
                occlusion += 1.0
            }
        }
    }
    occlusion = (Double(ntheta * nphi) - occlusion) / Double(ntheta * nphi)

    return Vector(x: occlusion, y: occlusion, z: occlusion)
}

public func render(w : Int, h : Int, nsubsamples : Int) -> [UInt8]
{
    var img = [UInt8](repeating: 0, count: w * h * 3)
    var fimg = [Double](repeating: 0, count: w * h * 3)
    
    for y in 0..<h {
        for x in 0..<w {
            for v in 0..<nsubsamples {
                for u in 0..<nsubsamples     {
                    let w2 = Double(w) / 2.0
                    let h2 = Double(h) / 2.0
                    let px = (Double(x) + (Double(u) / Double(nsubsamples)) - w2) / w2
                    let py = -(Double(y) + (Double(v) / Double(nsubsamples)) - h2) / h2
                    
                    let ray = Ray(org: Vector(x: 0.0, y: 0.0, z: 0.0),
                                  dir: Vector(x: px, y: py, z: -1.0).normalize())
                    var isect = Isect(t: 1.0e+17, p: Vector.zero, n: Vector.zero, hit: false)
                    isect = spheres[0].rayIntersect(isect: isect, ray: ray)
                    isect = spheres[1].rayIntersect(isect: isect, ray: ray)
                    isect = spheres[2].rayIntersect(isect: isect, ray: ray)
                    isect = plane.rayIntersect(isect: isect, ray: ray)
                    
                    if isect.hit {
                        let col = ambient_occlusion(isect: isect);
                        
                        fimg[3 * (y * w + x) + 0] += col.x
                        fimg[3 * (y * w + x) + 1] += col.y
                        fimg[3 * (y * w + x) + 2] += col.z
                    }
                    
                }
            }
            
            fimg[3 * (y * w + x) + 0] /= Double(nsubsamples * nsubsamples)
            fimg[3 * (y * w + x) + 1] /= Double(nsubsamples * nsubsamples)
            fimg[3 * (y * w + x) + 2] /= Double(nsubsamples * nsubsamples)
            
            img[3 * (y * w + x) + 0] = (fimg[3 * (y * w + x) + 0]).clamp()
            img[3 * (y * w + x) + 1] = (fimg[3 * (y * w + x) + 1]).clamp()
            img[3 * (y * w + x) + 2] = (fimg[3 * (y * w + x) + 2]).clamp()
        }
    }
    
    return img
}
