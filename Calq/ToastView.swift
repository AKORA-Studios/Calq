//
//  ToastView.swift
//  Calq
//
//  Created by Kiara on 15.07.23.
//

import SwiftUI

enum ToastStyles: String {
    case success
    case error
    case info
}

class ToastControl: ObservableObject {
    @Published var isPresented = false
    
    @Published var message = "SomeMessage"
    @Published var type: ToastStyles = .info
    
    init(isPresented: Bool = false) {
        self.isPresented = isPresented
    }
    
    func hide() {
        isPresented = false
    }
    
    func show(_ message: String = "SomeMessage", _ type: ToastStyles = .info) {
        self.message = message.localized
        self.type = type
        isPresented = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            isPresented = false
        }
    }
    
    func color() -> Color {
        switch type {
        case .info:
            return Color.accentColor
        case .success:
            return Color.green
        case .error:
            return Color.red
        }
    }
}

struct ToastView: View {
    @EnvironmentObject var toastControl: ToastControl
    
    var body: some View {
        if toastControl.isPresented {
            
            bodyView()
        } else {
            EmptyView()
        }
    }
    
    func bodyView() -> some View {
        VStack(alignment: .leading) {
            HStack(alignment: .top) {
              VStack(alignment: .leading) {
                  Text(toastControl.message)
                        .font(.system(size: 12))
                        .foregroundColor(Color.black.opacity(0.6))
                }
                
                Spacer(minLength: 10)
                
                Button {
                    toastControl.hide()
                } label: {
                    Image(systemName: "xmark")
                        .foregroundColor(Color.black)
                }.accessibilityIdentifier(Ident.Toast.cancelButton)
            }
            .padding()
        }
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(toastControl.color())
                .frame(width: 6)
                .clipped()
            , alignment: .leading
        )
        .frame(minWidth: 0, maxWidth: .infinity)
        .cornerRadius(8)
        .shadow(color: Color.black.opacity(0.25), radius: 4, x: 0, y: 1)
        .padding(.horizontal, 16)
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
