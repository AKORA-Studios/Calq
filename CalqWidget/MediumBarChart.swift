//
//  MediumBarChart.swift
//  CalqWidgetExtension
//
//  Created by Kiara on 09.03.23.
//

import SwiftUI

struct BarChartWidgetView: View {
    @State var subjects: [UserSubject] = Util.getAllSubjects()
    var settings = Util.getSettings()
    
    var body: some View {
        GeometryReader { geo in
            let fullHeigth = geo.size.height - 30
            VStack(alignment: .center) {
                if subjects.isEmpty {
                    EmptyMediumView()
                } else {
                    HStack {
                        ForEach(subjects, id: \.self) { subj in
                            let average = Util.getSubjectAverage(subj)
                            let grade =  (average * 100) / 15.0
                            let color = getSubjectColor(subj)
                            
                            VStack(spacing: 0) {
                                ZStack(alignment: .bottom) {
                                    Rectangle().frame( height: fullHeigth).foregroundColor(Color(.systemGray4)).topCorner()
                                    Rectangle().frame( height: (fullHeigth * (grade / 100.0))).foregroundColor(color).topCorner()
                                    Text(String(Int(average)))
                                        .font(.footnote)
                                        .fontWeight(.light)
                                        .foregroundColor(.black)
                                }
                                Text(subj.name.prefix(2).uppercased()).font(.system(size: 9)).frame(height: 10)
                            }
                        }
                    }
                }
            }.padding(10)
        }
    }
}

struct EmptyMediumView: View {
    var body: some View {
        VStack {
            Spacer()
            HStack {
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                Text("Du hast noch keine Noten hinzugefügt qwq").multilineTextAlignment(.center)
                Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
            }
            Spacer()
        }
        .padding()
    }
}
