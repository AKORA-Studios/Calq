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
    @Binding var year: Int
    
    var body: some View {
        GeometryReader {geo in
            VStack(spacing: 4){
                //Upper sEgemnt
                HStack(spacing: 0){
                    ForEach( 0...14, id: \.self ){i in
                        GradeSegment(colors: $colors, values: $values, width: geo.size.width/15, index: i)
                    }
                }.padding(0)
                
                //Lower Segment
                HStack(spacing: 0){
                    ForEach(values, id: \.self) { value in
                        Text(value).frame(width: geo.size.width/15, height: 10)
                    }
                }.padding(0)
            }.frame(height: 30).onAppear(perform: setData).padding(.vertical, 0)
                .onChange(of: gradeType) { _ in
                    setData()
                }
                .onChange(of: year) { _ in
                    setData()
                }
        }
    }
    
    func reset(){
        colors = get15colors()
        values = get15Values()
    }
    
    func setData() {
        if(subject == nil){return reset()}
        if(Util.filterTests(subject!).isEmpty){return reset()}
        let allTests = Util.filterTests(subject!, checkinactive: false)
        if(allTests.isEmpty){return reset()}
        let tests = allTests.filter{$0.year == year}
        if(tests.isEmpty){return reset()}
        
        //calculation old grade
        let weigth = Double(Util.getSettings()!.weightBigGrades)!
        let weightSmall = 1 - weigth
        let averageOld: Int = Int(round(Util.testAverage(tests)))
        
        let bigTests = tests.filter{$0.big}.map{Int($0.grade)}
        let smallTests = tests.filter{!$0.big}.map{Int($0.grade)}
        
        let big =  Util.average(bigTests)
        let small = Util.average(smallTests)
        
        var worseLast: Int = 99
        var betterLast: Int = 0
        var sameLast: Int = 99
        
        for i in 0...14 {
            var newAverage: Int = 0
            
            if(gradeType == 1){ //small
                var gradeArr = smallTests
                gradeArr.append(i)
                
                if(bigTests.isEmpty) {
                    newAverage = Int(round(Util.average(gradeArr)))
                } else {
                    newAverage = Int(round(weigth * big + weightSmall * Util.average(gradeArr)))
                }
                
            }else { //big
                var gradeArr = bigTests
                gradeArr.append(i)
                
                if(smallTests.isEmpty) {
                    newAverage = Int(round(Util.average(gradeArr)))
                } else {
                    newAverage = Int(round(weigth * Util.average(gradeArr) + weightSmall * small))
                }
            }
            
            var str = "\(newAverage)"
            //push colors
            if(averageOld > newAverage){
                if(worseLast == newAverage){str = " "}
                colors[i] = .red
                values[i] = str
                worseLast = newAverage
                
            } else if(newAverage > averageOld ){
                if(betterLast == newAverage){str = " "}
                colors[i] = .green
                values[i] = str
                betterLast = newAverage
            }
            else {
                if(sameLast == averageOld){str = " "}
                sameLast = averageOld
                colors[i] = .gray
                values[i] = str
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
        arr.append(" ")
    }
    return arr
}
