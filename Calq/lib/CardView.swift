//
//  CardView.swift
//  Calq
//
//  Created by Kiara on 21.06.23.
//

import SwiftUI


struct CardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
    }
}

struct CardViewPreview: PreviewProvider {
    static var previews: some View {
        
        Rectangle().frame(width: 100, height: 100)
            .foregroundColor(.clear)
            .background(CardView())
            .previewLayout(.fixed(width: 200, height: 200))
    }
}
