//
//  ExamWidget.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 16.19.23.
//

import SwiftUI

struct WidgetExamEntrys {
    let entrycount: Int
    let blockpoints2: Int
    let blockpoints1: Int
    let entries: [WidgetExamEntry]
    
    static let example = WidgetExamEntrys(entrycount: 5, blockpoints2: 100, blockpoints1: 300, entries: WidgetExamEntry.example)
    
    static func createWidgetEntrys() -> WidgetExamEntrys {
        var arr: [WidgetExamEntry] = []
        let blockpoints = generateBlockTwo()
        let blockpoints1 = generateBlockOne()
        let entrycount = Util.getSettings().hasFiveExams ? 5 : 4
        
        for num in (1...entrycount) {
            let subject = getExam(num)
            guard let sub = subject else {
                arr.append(WidgetExamEntry(points: 0, name: ""))
                continue
            }
            arr.append(WidgetExamEntry(points: Int(sub.exampoints), color: getSubjectColor(sub), name: sub.name))
        }
        return WidgetExamEntrys(entrycount: entrycount, blockpoints2: blockpoints, blockpoints1: blockpoints1, entries: arr)
    }
}

struct WidgetExamEntry: Identifiable {
    var points: Int
    var color: Color = .blue
    var name: String
    let id = UUID()
    
    static let example = [
        WidgetExamEntry(points: 12, name: "a"),
        WidgetExamEntry(points: 1, name: "b"),
        WidgetExamEntry(points: 6, name: "c"),
        WidgetExamEntry(points: 3, name: "d"),
        WidgetExamEntry(points: 0, name: "e")
    ]
}

struct ExamWidget: View {
    @Environment(\.colorScheme) var colorScheme
    var value: WidgetExamEntrys
    private let gray = Color(.systemGray2)
    
    var body: some View {
        VStack {
            if value.entries.isEmpty {
                EmptyMediumView()
            } else {
                HStack {
                    Text("ExamChartWidget_DisplayTitle")
                    Spacer()
                    Text("ExamChartWidget_BlockTitle")
                }.frame(height: 10)
                
                HStack {
                    VStack {
                        ForEach(value.entries.indices) { index in
                            examView(index)
                        }
                    }
                    blockView().frame(width: 20)
                    blockView("II").frame(width: 20)
                }
            }
        }.padding()
            .background(widgteBackground(colorScheme))
    }
    
    func blockView(_ name: String = "I") -> some View {
        GeometryReader { geo in
            let points = name == "I" ? value.blockpoints1 : value.blockpoints2
            let maxPoints = name == "I" ? 600.0 : 300.0
            
            let fullHeight = geo.size.height - 12
            let percent = CGFloat(Double(points)/maxPoints)
            
            VStack(spacing: 2) {
                ZStack(alignment: .bottom) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(gray)
                        .frame(height: fullHeight)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.accentColor)
                        .frame(height: fullHeight * percent)
                    VStack(spacing: 0) {
                        Text("\(points)")
                            .rotationEffect(.degrees(-90))
                            .font(.footnote)
                            .frame(height: fullHeight, alignment: .bottomTrailing)
                            .fixedSize(horizontal: true, vertical: false)
                        Spacer()
                    }
                }
                
                Text(name)
                    .font(.footnote)
                    .foregroundColor(gray)
                    .frame(height: 10)
            }
        }
    }
    
    func examView(_ index: Int) -> some View {
        GeometryReader { geo in
            let exam = value.entries[index]
            let fullWidth = geo.size.width - 12
            let percent = CGFloat(Double(exam.points)/15.0)
            
            HStack(spacing: 2) {
                Text("\(index+1)")
                    .font(.footnote)
                    .foregroundColor(gray)
                    .frame(width: 10)
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(gray)
                        .frame(width: fullWidth)
                    RoundedRectangle(cornerRadius: 8)
                        .fill(exam.color)
                        .frame(width: fullWidth * percent)
                    HStack {
                        Text(exam.name)
                        Spacer()
                        Text(String(exam.points))
                    }.padding(.horizontal)
                }
            }
        }
    }
}
