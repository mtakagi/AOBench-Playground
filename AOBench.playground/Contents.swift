//: Playground - noun: a place where people can play

import Cocoa

let NSubSamples = 2
let width = 256
let height = 256

func saveppm(fname : String, w : Int, h : Int, img : [UInt8])
{
    let path = (NSTemporaryDirectory() as NSString).appendingPathComponent(fname)
    guard let fp = fopen(path, "wb") else {
        print("Open Error")
        return
    }
    
    vfprintf(fp, "P6\n", getVaList([]));
    vfprintf(fp, "%d %d\n", getVaList([w, h]));
    vfprintf(fp, "255\n", getVaList([]));
    fwrite(img, w * h * 3, 1, fp);
    fclose(fp);
    let image = NSImage(contentsOfFile: path)
}

let img = render(w: width, h: height, nsubsamples: NSubSamples);
saveppm(fname: "ao.ppm", w: width, h: height, img: img);
