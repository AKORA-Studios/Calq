//
//  CardView.swift
//  Calq
//
//  Created by Kiara on 21.06.23.
//

import SwiftUI

struct CardView: View {
    let color = Color.gray.opacity(0.3)
    
    var body: some View {
        /*
         if #available(iOS 16.0, *) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.backgroundColor.shadow(.drop(color: .cardShadow, radius: 3)))
                
            } else {
                RoundedRectangle(cornerRadius: 8).fill(Color.clear)
                    .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(Color.cardShadow))
                
            }
         */
        RoundedRectangle(cornerRadius: 8).fill(Color.clear)
            .overlay(RoundedRectangle(cornerRadius: 8).stroke(lineWidth: 1).foregroundColor(color))
    }
}

struct CardViewPreview: PreviewProvider {
    static var previews: some View {
        
        CardContainer {
            Text("h")
        }
        .previewLayout(.fixed(width: 200, height: 200))
    }
}

struct CardContainer<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        ZStack {
            content
                .padding(15)
        }.background(CardView())
            .padding(2)
    }
}
