//
//  Colors.swift
//  BrandeisClassSearchIPHONE
//
//  Created by Yuanze Hu on 2/8/17.
//  Copyright © 2017 Yuanze Hu. All rights reserved.
//

import UIKit

struct RGB {
    let R: CGFloat
    let G: CGFloat
    let B: CGFloat
}


class Colors {
    
    static let colorsCombo = [RGB(R: 255.0/255.0,G: 130.0/255.0,B: 124.0/255.0),RGB(R: 180.0/255.0,G: 242.0/255.0,B: 210.0/255.0),
                              RGB(R: 253.0/255.0,G: 246.0/255.0,B: 126.0/255.0),RGB(R: 242.0/255.0,G: 220.0/255.0,B: 222.0/255.0),
                       RGB(R: 85.0/255.0,G: 135.0/255.0,B: 162.0/255.0),RGB(R: 209.0/255.0,G: 175.0/255.0,B: 147.0/255.0),
                       RGB(R: 102.0/255.0,G: 100.0/255.0,B: 139.0/255.0),RGB(R: 63.0/255.0,G: 80.0/255.0,B: 93.0/255.0)]
    
    
    static func getColor(index: Int) -> UIColor {
        if index < 0 {
            return UIColor(red: 0.0/255.0, green: 0.0/255.0, blue: 0.0/255.0, alpha: 1.0)
        }
        if index < colorsCombo.count{
            return UIColor(red: colorsCombo[index].R, green: colorsCombo[index].G, blue: colorsCombo[index].B, alpha: 1.0)
        }else{
            print("Exceed the number of colors(\(colorsCombo.count)), darken the last color \(index - colorsCombo.count + 1) times to generate new colors.")
            let t = (index - colorsCombo.count + 1)
            let darkenRgb = darken(rgb: colorsCombo[colorsCombo.count - 1], times: t)
            return UIColor(red: darkenRgb.R, green: darkenRgb.G, blue: darkenRgb.B, alpha: 1.0)
        }
    }
    
    static func darken (rgb: RGB, times: Int) -> RGB{
        if times <= 0{
            return rgb
        }else{
            return darken(rgb: RGB(R: rgb.R * 0.7,G: rgb.G * 0.7,B: rgb.B * 0.7), times: times - 1)
        }
    }
}
