//
//  ExamWidget.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 16.19.23.
//

import SwiftUI
    
    
struct WidgetExamEntry: Identifiable {
    var points: Int
    var name: String
    let id = UUID()
}

struct ExamWidget: View {
    var exams = [WidgetExamEntry]()
    var blockPoints: Int = 0

    var body: some View {
        VStack {
            RoundedRectangle(cornerRadius: 8)
            ForEach(exams) { exam in
                examView(exam)
            }
        }
    }
    
    func examView(_ exam: WidgetExamEntry) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                Text(exam.name)
            }
            Text(String(exam.points))
        }
    }
}
  
