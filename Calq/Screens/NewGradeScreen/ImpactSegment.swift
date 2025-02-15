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
    @Binding var gradeType: Int16
    @Binding var year: Int
    
    var body: some View {
        GeometryReader {geo in
            VStack(spacing: 4) {
                // Upper Segment
                HStack(spacing: 0) {
                    ForEach( 0...15, id: \.self ) {i in
                        GradeSegment(colors: $colors, values: $values, width: geo.size.width/16, index: i)
                    }
                }.padding(0)
                
                // Lower Segment
                HStack(spacing: 0) {
                    ForEach(values, id: \.self) { value in
                        Text(value).frame(width: geo.size.width/16, height: 10)
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
    
    func reset() {
        colors = get15colors()
        values = get15Values()
    }
    
    func setData() {
        guard let subject = subject else { return reset() }
        let tests = Util.getAllSubjectTests(subject).filter { $0.year == year }
        if tests.isEmpty { return reset() }
        
        let averageOld: Int = Int(round(Util.testAverage(tests)))
        
        var worseLast: Int = 99
        var betterLast: Int = 0
        var sameLast: Int = 99
        
        let types = Util.getTypes()
        
        // calc new average
        for i in 0...15 {
            var newAverage: Int = 0
            var gradeWeigths = 0.0
            var avgArr: [Double] = []
            
            for x in types {
                var filtered = tests.filter {$0.type == x.id}.map { Int($0.grade) }
               
                let weigth = Double(Double(x.weigth)/100)
                gradeWeigths += weigth
                
                if x.id == gradeType {
                    filtered.append(i)
                }
                
                let avg = Util.average(filtered)
                avgArr.append(Double(avg * weigth))
            }
            
            let num = avgArr.reduce(0, +)/gradeWeigths
            newAverage = Int(round(num))
        
            // display numbers
            var str = "\(newAverage)"
            // push colors
            if averageOld > newAverage {
                if worseLast == newAverage {str = " "}
                colors[i] = .red
                values[i] = str
                worseLast = newAverage
                
            } else if newAverage > averageOld {
                if betterLast == newAverage {str = " "}
                colors[i] = .green
                values[i] = str
                betterLast = newAverage
            } else {
                if sameLast == averageOld {str = " "}
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
        ZStack {
            if index == 0 {
                Rectangle().fill((colors[index])).frame(width: width).leftcorner()
            }
            if index == 15 {
                Rectangle().fill((colors[index])).frame(width: width).rightCorner()
            }
            if index != 0 && index != 15 {
                Rectangle().fill((colors[index])).frame(width: width)
            }
            Text(String(index))
        }
    }
}

// Populate arrays
func get15colors() -> [Color] {
    var arr: [Color] = []
    for _ in 0...15 {
        arr.append(Color.gray)
    }
    return arr
}

func get15Values() -> [String] {
    var arr: [String] = []
    for _ in 0...15 {
        arr.append(" ")
    }
    return arr
}
