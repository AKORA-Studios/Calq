//
//  BarChartView.swift
//  Calq
//
//  Created by Kiara on 11.12.21.
//

import SwiftUI

struct BarChart: View {
    @Binding var values: [BarEntry]
    @State var heigth: CGFloat = 300
    @State var average: Double = 0.0
    @State var round: Bool = false
    
    var body: some View {
        GeometryReader{ geo in
            let fullHeigth = geo.size.height - 15
         //   let fullWidth = geo.size.width
        
            ZStack {
                //grid
                //Rectangle().fill(Color.black).frame(height: 2).offset(x: -2,y: (fullHeigth/2)) //x axis
                //  Rectangle().fill(Color.gray).frame(height: 1).offset(y: (fullHeigth/2) - heigth - 2) //tick 15
                //  Rectangle().fill(Color.gray).frame(height: 1).offset(y: (fullHeigth/2) - m10() - 2) //tick 10
                // Rectangle().fill(Color.gray).frame(height: 1).offset(y: (fullHeigth/2) - m5() - 2) //tick 5
             /*   if(average != 0.0){
                    Rectangle().fill(Color.gray).frame(height: 1).offset(y: (fullHeigth/2) - av() - 2)
                }*/
                // Rectangle().fill(Color.gray).frame(width:1).offset(x: (fullWidth/2) - fullWidth - 2, y: 1) // y axis
                
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
                    //   Text(subName)
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


struct BarEntry: Hashable{
    var color: Color = .accentColor
    var value: Double = 0.5
    var text: String = ""
}

func createSubjectBarData() -> [BarEntry] {
    var arr: [BarEntry] = []
    let subjects = Util.getAllSubjects()
    
    for sub in subjects{
        let color = getSubjectColor(sub)
        arr.append(BarEntry(color: color, value: Util.getSubjectAverage(sub), text: sub.name))
    }
    
    return arr
}
