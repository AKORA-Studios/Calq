//
//  ColorExtension.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI


extension Color {
    init(hexString:String) {
        let hexString:String = hexString.trimmingCharacters(
            in: CharacterSet.whitespacesAndNewlines
        )
        var scanner            = Scanner(string: hexString)
        
        if (hexString.hasPrefix("#")) {
            scanner = Scanner(string: String(hexString.split(separator: "#")[0]))
        }
        
        var color:UInt64 = 0
        scanner.scanHexInt64(&color)
        
        let mask = 0x000000FF
        let r = Int(color >> 16) & mask
        let g = Int(color >> 8) & mask
        let b = Int(color) & mask
        
        let red   = CGFloat(r) / 255.0
        let green = CGFloat(g) / 255.0
        let blue  = CGFloat(b) / 255.0
        
        self.init(red:red, green:green, blue:blue)
    }
}
