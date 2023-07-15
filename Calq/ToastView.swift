//
//  ToastView.swift
//  Calq
//
//  Created by Kiara on 15.07.23.
//

import SwiftUI

class ToastControl: ObservableObject {
    @Published var isPresented = false
    
    @Published var message = "SomeMessage"
    @Published var color = Color.accentColor
    
    init(isPresented: Bool = false) {
        self.isPresented = isPresented
    }
    
    func hide() {
        isPresented = false
    }
    
    func show(_ message: String = "SomeMessage", _ color: Color = .accentColor) {
        self.message = message
        self.color = color
        isPresented = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            isPresented = false
        }
    }
}

struct ToastView: View {
    @EnvironmentObject var toastControl: ToastControl
    
    var body: some View {
        ZStack {
            if toastControl.isPresented {
                RoundedRectangle(cornerRadius: 8).fill(toastControl.color)
                    .frame(height: 50)
                    .padding()
                    .shadow(radius: 40)
                Text(toastControl.message)
            }
        }
        .onTapGesture {
            toastControl.hide()
        }
        
    }
}

struct ToastView_Preview: PreviewProvider {
    static var previews: some View {
        ZStack(alignment: .top) {
            ToastView()
        }
        .environmentObject(ToastControl(isPresented: true))
    }
}
