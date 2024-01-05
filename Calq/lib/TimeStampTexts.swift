//
//  TimeStampTexts.swift
//  Calq
//
//  Created by Kiara on 05.01.24.
//

import SwiftUI

struct TimeStampTexts: View {
    var createdAt: Date
    var lastEditedAt: Date
    
    var body: some View {
        VStack {
            Text("editSubCreatedAt").bold() + Text(formatDate(createdAt))
            Text("editSubLastEditedAt").bold() + Text(formatDate(lastEditedAt))
        }.multilineTextAlignment(.center)
            .foregroundColor(.gray)
            .font(.footnote)
    }
    
    private func formatDate(_ date: Date) -> String {
        let Formatter = DateFormatter()
        Formatter.dateFormat = "dd.MM.yy HH:mm"
        return Formatter.string(from: date)
    }
}
