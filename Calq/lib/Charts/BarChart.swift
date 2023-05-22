//
//  BarChartView.swift
//  Calq
//
//  Created by Kiara on 11.12.21.
//

import SwiftUI

struct BarChart: View {
    @Binding var values: [BarChartEntry]
    @State var heigth: CGFloat = 300
    @State var average: Double = 0.0
    @State var round: Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            let fullHeigth = geo.size.height - 15
            
            ZStack {
                //bars
                HStack {
                    ForEach(values, id:\.self){ val in
                        VStack(spacing: 0){
                            ZStack(alignment: .bottom){
                                Rectangle().frame( height: fullHeigth).foregroundColor(Color(.systemGray4)).topCorner()
                                Rectangle().frame( height: (fullHeigth * val.value / 15.0)).foregroundColor(val.color).topCorner()
                                Text(getDescription(val.value))
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .foregroundColor(.black)
                            }
                            Text(val.text.prefix(3).uppercased()).font(.system(size: 9)).frame(height: 15)
                        }
                    }
                    if(values.isEmpty){
                        Spacer()
                        Text("EmptyBarChart")
                        Spacer()
                    }
                }
            }
        }.frame(height: heigth)
    }
    
    func getDescription(_ value: Double) -> String{
        return String(format: (round ? "%.0f" : "%.2f"), value)
    }
    
    func m10()-> CGFloat{
        return CGFloat(heigth * 2/3)
    }
    
    func m5()-> CGFloat{
        return CGFloat(heigth * 1/3)
    }
    
    func av()->CGFloat{
        return CGFloat(heigth * (average / 15.0))
    }
}

func createSubjectBarData() -> [BarChartEntry] {
    var arr: [BarChartEntry] = []
    let subjects = Util.getAllSubjects()
    
    for sub in subjects{
        let color = getSubjectColor(sub)
        arr.append(BarChartEntry(color: color, value: Util.getSubjectAverage(sub), text: sub.name))
    }
    
    return arr
}

struct BarChartEntry: Hashable{
    var color: Color = .accentColor
    var value: Double = 0.5
    var text: String = ""
}

extension BarChartEntry {
    static let exmaple = [
        BarChartEntry(color: pastelColors[0], value: 10, text: "DE"),
        BarChartEntry(color: pastelColors[1], value: 11, text: "EN"),
        BarChartEntry(color: pastelColors[2], value: 13, text: "MA"),
        BarChartEntry(color: pastelColors[3], value: 8, text: "Geo"),
        BarChartEntry(color: pastelColors[4], value: 9, text: "lat"),
        BarChartEntry(color: pastelColors[5], value: 10, text: "spo"),
        BarChartEntry(color: pastelColors[6], value: 11, text: "grw"),
        BarChartEntry(color: pastelColors[7], value: 9, text: "abc"),
        BarChartEntry(color: pastelColors[8], value: 12, text: "def"),
    ]
}
