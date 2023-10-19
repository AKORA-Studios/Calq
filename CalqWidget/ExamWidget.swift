//
//  ExamWidget.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 16.19.23.
//

import SwiftUI

struct WidgetExamEntrys {
    let entrycount: Int
    let blockpoints: Int
    let entries: [WidgetExamEntry]
    
    static let example = WidgetExamEntrys(entrycount: 5, blockpoints: 100, entries: WidgetExamEntry.example)
    
    static func createWidgetEntrys() -> WidgetExamEntrys {
        var arr: [WidgetExamEntry] = []
        let blockpoints = generateBlockTwo()
        let entrycount = Util.getSettings().hasFiveExams ? 5 : 4
        
        for num in (1...entrycount) {
            let subject = getExam(num)
            guard let sub = subject else {
                arr.append(WidgetExamEntry(points: 0, name: ""))
                continue
            }
            arr.append(WidgetExamEntry(points: Int(sub.exampoints), color: getSubjectColor(sub), name: sub.name))
        }
        return WidgetExamEntrys(entrycount: entrycount, blockpoints: blockpoints, entries: arr)
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
    var value: WidgetExamEntrys
    
    var body: some View {
        VStack {
            if value.entries.isEmpty {
                EmptyMediumView()
            } else {
                HStack {
                    Text("ExamChartWidget_DisplayTitle")
                    Spacer()
                    Text(String(value.blockpoints))
                }.frame(height: 10)
                
                HStack {
                    VStack {
                        ForEach(value.entries) { exam in
                            examView(exam)
                        }
                    }
                    blockView().frame(width: 20)
                }
            }
        }.padding()
    }
    
    func blockView() -> some View {
        GeometryReader { geo in
            let fullHeight = geo.size.height
            let percent = CGFloat(Double(value.blockpoints)/300.0)
            
            ZStack(alignment: .bottom) {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray)
                    .frame(height: fullHeight)
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.accentColor)
                    .frame(height: fullHeight * percent)
            }
        }
    }
    
    func examView(_ exam: WidgetExamEntry) -> some View {
        GeometryReader { geo in
            let fullWidth = geo.size.width
            let percent = CGFloat(Double(exam.points)/15.0)
            
            HStack {
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color.gray)
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
