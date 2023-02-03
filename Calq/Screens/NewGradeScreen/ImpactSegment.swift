//
//  ImpactSegment.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

struct ImpactSegment: View {
    @State var colors: [Color] = get15colors()
    @State var values: [String] = get15Values()
    @Binding var subject: UserSubject?
    @Binding var gradeType: Int
    
    var body: some View {
        GeometryReader {geo in
            VStack(spacing: 4){
                HStack(spacing: 0){
                    ForEach( 0...14, id: \.self ){i in
                        GradeSegment(colors: $colors, values: $values, width: geo.size.width/15, index: i)
                    }
                }.padding(0)
                LowerSegment(values: $values).frame(height: 10)
            }.frame(height: 30).onAppear(perform: generateColors).padding(.vertical, 0).onChange(of: gradeType) { _ in
                generateColors()
            }
        }
    }
    
    
    func generateColors() {
        if(subject == nil){ return }
        if(filterTests(subject!).isEmpty){return}
        let tests = filterTests(subject!)
        
        //calculation old grade
        let weigth = Double(Util.getSettings()!.weightBigGrades)!
        let weightSmall = 1 - weigth
        let averageOld: Int = Int(round(Util.testAverage(tests)))
        
        let big =  Util.testAverage(tests.filter{$0.big})
        let small = Util.testAverage(tests.filter{!$0.big})
        
        var worseLast: Int = 99
        var betterLast: Int = 99
        var sameLast: Int = 99
        
        for i in 0...14 {
            var newAverage: Int = 0
            
            if(gradeType == 1){ //small
                var gradeArr = tests.filter{!$0.big}.map{Int($0.grade)}
                gradeArr.append(i)
                
                if(tests.filter{$0.big}.count == 0) {
                    newAverage = Int(round(Util.average(gradeArr)))
                } else {
                        newAverage = Int(round(weigth * big + weightSmall * Util.average(gradeArr)))
                    }
                
            }else { //big
                var gradeArr = tests.filter{$0.big}.map{Int($0.grade)}
                gradeArr.append(i)
                
                if(tests.filter{!$0.big}.count == 0) {
                    newAverage = Int(round(Util.average(gradeArr)))
                } else {
                    newAverage = Int(round(weigth * Util.average(gradeArr) + weightSmall * small))
                }
            }
            
            var str = "\(newAverage)"
            //push colors
            if(averageOld > newAverage){
                if(worseLast == newAverage) {str = " "}
                colors[i] = .red
                values[i] = str
                worseLast = newAverage
                
            } else if(newAverage > averageOld ){
                if(betterLast == newAverage) {str = " "}
                colors[i] = .green
                values[i] = str
                betterLast = newAverage
            }
            else {
                if( sameLast == averageOld) {str = " "}
                sameLast = averageOld
                values[i] = str
            }
        }
    }
}

struct LowerSegment: View {
    @Binding var values: [String]
    
    var body: some View {
        HStack{
            ForEach(values, id: \.self) { value in
                Text(value)
            }
        }
    }
}

struct GradeSegment: View {
    @Binding var colors: [Color]
    @Binding var values: [String]
    var width: CGFloat
    var index: Int
    
    var body: some View {
            ZStack{
                if(index == 0){
                    Rectangle().fill((colors[index])).frame(width: width).leftcorner()
                }
                if(index == 14){
                    Rectangle().fill((colors[index])).frame(width: width).rightCorner()
                }
                if(index != 0 && index != 14){
                    Rectangle().fill((colors[index])).frame(width: width)
                }
                Text(String(index+1))
            }
        }
}

//Populate arrays
func get15colors()-> [Color]{
    var arr: [Color] = []
    for _ in 1...15 {
        arr.append(Color.gray)
    }
    return arr
}


func get15Values() -> [String]{
    var arr: [String] = []
    for _ in 1...15 {
        arr.append("")
    }
    return arr
}

//Round left and right side
struct RoundedCorner: Shape {
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: 4, height: 4))
        return Path(path.cgPath)
    }
}

extension View {
    func leftcorner() -> some View {
        clipShape(RoundedCorner(corners: [.topLeft, .bottomLeft]))
    }
    
    func rightCorner() -> some View {
        clipShape(RoundedCorner(corners: [.topRight, .bottomRight]))
    }
}
