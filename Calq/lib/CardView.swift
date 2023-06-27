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
    }
}
