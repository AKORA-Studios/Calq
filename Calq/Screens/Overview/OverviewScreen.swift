//
//  OverviewScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct OverviewScreen: View {
    @State var blockPoints: Double = Double(generateBlockOne()) + Double(generateBlockTwo())
    @State var averagePercent: Double = Util.generalAverage() / 15
    @State var averageText: String = String(format: "%.2f", Util.generalAverage())
    @State var halfyears = [BarEntry(value: Util.generalAverage(1)),BarEntry(value: Util.generalAverage(2)),BarEntry(value: Util.generalAverage(3)),BarEntry(value: Util.generalAverage(4))]
    @State var generalAverage = Util.generalAverage()
    @State var subjectValues: [BarEntry] = createSubjectBarData()
    @State var gradeText = ""
    @State var blockCircleText = ""
    @State var blockPercent = 0.0
    @State var subjects = Util.getAllSubjects()
    
    
    @State var degrees1: Double = 0.0
    @State var degrees2: Double = 0.0
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false){
                VStack{
                    ZStack{
                        BarChart(values: $subjectValues, heigth: 200, average: generalAverage, round: true).padding()
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                    }
                    
                    ZStack{
                        VStack(alignment: .leading, spacing: 5){
                        Text("Verlauf")
                        LineChart(subjects: subjects)
                        }.padding()
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                    }
                    
                    ZStack{
                        VStack(alignment: .leading, spacing: 5){
                            Text("Halbjahre")
                            BarChart(values: $halfyears, heigth: 150)
                        }.padding()
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                    }
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))//.frame(height: 100)
                        HStack{
                            VStack(spacing: 5){
                                Text("Fächerschnitt")
                                CircleChart(perrcent: $averagePercent, textDescription: "Durchschnitt aller Fächer ohne Prüfungsnoten", upperText: $averageText, lowerText: $gradeText).frame(height: 150)
                            }
                            VStack(spacing: 5){
                                Text("Abischnitt")
                                CircleChart(perrcent: $blockPercent, textDescription: "Durchschnitt mit Prüfungsnoten)", upperText: $blockCircleText, lowerText: Binding.constant("Ø")).frame(height: 150)
                            }
                        }.padding()
                       
                    }
                }
            }.padding(.horizontal)
                .navigationTitle("Übersicht")
                .onAppear{
                    subjects = Util.getAllSubjects()
                    gradeText = grade()
                    blockCircleText = getGradeData()
                    subjectValues = createSubjectBarData()
                    blockPercent = Double((blockPoints/900.0))
                }
        }
    }
    
    func grade()->String{
        return String(format: "%.2f", Util.grade(number: Util.generalAverage()))
    }
    
    func getGradeData()-> String{
        let blockGrade = Util.grade(number: Double(blockPoints * 15 / 900))
        return  String(format: "%.2f", blockGrade)
    }
}
