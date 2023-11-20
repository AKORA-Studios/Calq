//
//  WidgetBackgroundExtension.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 20.11.23.
//

import SwiftUI

extension View {
    func widgteBackground(_ colorScheme: ColorScheme) -> Color {
        return colorScheme == .dark ? Color(hexString: "#303030") : .white
    }
}
