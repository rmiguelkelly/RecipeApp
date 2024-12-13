//
//  Extensions.swift
//  RecipeApp
//
//  Created by Ronan Kelly on 12/12/24.
//

import UIKit
import SwiftUI

extension Color {
    
    // Create a color from a hex code
    static func hex(_ rgb: Int) -> Color {
        let r = (rgb >> 16) & 0xFF
        let g = (rgb >> 8) & 0xFF
        let b = rgb & 0xFF
        
        return Color(red: Double(r) / 255.0, green: Double(g) / 255.0, blue: Double(b) / 255.0)
    }
    
    static var customColor1: Color { Self.hex(0xd4e09b) }
    
    static var customColor2: Color { Self.hex(0xf6f4d2) }
    
    static var customColor3: Color { Self.hex(0xcbdfbd) }
    
    static var customColor4: Color { Self.hex(0xf19c79) }
}

extension View {
    func erase() -> AnyView {
        AnyView(self)
    }
}

extension Sequence where Element: Hashable {
    func set() -> Set<Element> {
        Set(self)
    }
}
