//
//  OverviewScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct OverviewScreen: View {
    @State var blockPoints: Double = Double(generateBlockOne()) + Double(generateBlockTwo())
    @State var average: Double = Util.generalAverage()
    @State var halfyears = [BarEntry(value: Util.generalAverage(1)),BarEntry(value: Util.generalAverage(2)),BarEntry(value: Util.generalAverage(3)),BarEntry(value: Util.generalAverage(4))]
    @State var generalAverage = Util.generalAverage()
    @State var subjectValues: [BarEntry] = createSubjectBarData()
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false){
                VStack{
                    ZStack{
                        BarChart(values: $subjectValues, heigth: 300, average: generalAverage, round: true).padding()
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                    }
                    
                    ZStack{
                        VStack(spacing: 5){
                            Text("Halbjahre")
                            BarChart(values: $halfyears, heigth: 150)
                        }.padding()
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                    }
                    
                    ZStack{
                        HStack{
                            VStack(spacing: 5){
                                Text("Fächerschnitt")
                                CircleChart(perrcent: average/15.0, upperText: String(format: "%.2f",average), lowerText: grade()).frame(height: 150)
                            }
                            VStack(spacing: 5){
                                Text("Abischnitt")
                                CircleChart(perrcent: Double((blockPoints/900.0)), upperText: getGradeData(), lowerText: "Ø").frame(height: 150)
                            }
                        }.padding()
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))//.frame(height: 100)
                    }
                }
            }.padding().onAppear{
            subjectValues = createSubjectBarData()
            }
        }
    }
    
    func grade()->String{
       
        return String(format: "%.2f", Util.grade(number: average))
    }
    
    func getGradeData()-> String{
        let blockGrade = Util.grade(number: Double(blockPoints * 15 / 900))
        return  String(format: "%.2f", blockGrade)
    }
}
