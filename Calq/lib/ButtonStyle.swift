//
//  ButtonStyle.swift
//  Calq
//
//  Created by Kiara on 06.03.23.
//

import SwiftUI

struct PrimaryStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 15)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor)
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}

struct SecondaryStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 15)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.accentColor.opacity(0.5))
            .cornerRadius(8)
            .foregroundColor(.white)
    }
}


struct DestructiveStyle: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .frame(height: 15)
            .frame(maxWidth: .infinity)
            .padding()
            .background(Color.red.opacity(0.5))
            .cornerRadius(8)
            .foregroundColor(.red)
    }
}

// MARK: ExamScreen Menu Button Styles
struct MenuPickerButton: ButtonStyle {
    let color: Color
    let active: Bool
    
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            configuration.label
            if(!active){
                Spacer()
                Image(systemName: "chevron.up.chevron.down").scaledToFit()
            }
        }
        .frame(height: 15)
        .frame(maxWidth: .infinity)
        .padding(5)
        .background(active ? color : Color.gray)
        .cornerRadius(8)
        .foregroundColor(.white)
    }
}


struct MenuPickerDestructive: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        HStack {
            Image(systemName: "xmark.circle")
            Spacer()
            configuration.label
        }
        .foregroundColor(Color.red)
    }
}


struct CardView: View {
    var body: some View {
        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
    }
}
