//
//  ViewExtension.swift
//  Calq
//
//  Created by Kiara on 15.02.23.
//

import SwiftUI

// Round left and right side
struct RoundedCorner: Shape {
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 4, height: 4))
        return Path(path.cgPath)
    }
}

extension View {
    func leftcorner() -> some View {
        clipShape(RoundedCorner(corners: [.topLeft, .bottomLeft]))
    }
    
    func rightCorner() -> some View {
        clipShape(RoundedCorner(corners: [.topRight, .bottomRight]))
    }
    
    func topCorner() -> some View {
        clipShape(RoundedCorner(corners: [.topLeft, .topRight]))
    }
}
