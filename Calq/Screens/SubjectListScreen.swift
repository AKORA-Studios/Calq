//
//  SubjectListScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SubjectListScreen: View {
    @State var subjects: [UserSubject] = getAllSubjects()
    
    var body: some View {
        VStack{
            Text("SubjectListScreen")
            List{
                Section{
                    ForEach(subjects){sub in
                        SubjectYearCell(subjects: subjects, subject: sub)
                    }
                }
                Section{
                    SummaryCell(inActiveYears: calcInactiveYearsCount(), activeMax: subjects.count * 4)
                }
            }
        }
    }
    
    func calcInactiveYearsCount()-> Int{
        if(subjects.count == 0) {return 0}
        var count: Int = 0
        
        for sub in subjects {
            let arr = getinactiveYears(sub)
            for num in arr {
                if(num == "") {continue}
                if Int(num) != nil { count += 1}
            }
        }
        return count
    }
    
    
}




struct SubjectYearCell: View {
    @StateObject var settings: AppSettings = getSettings()!
    var subjects: [UserSubject] = getAllSubjects()
    @State var subject: UserSubject
    @State var colors: [Color] = [Color.gray, Color.gray, Color.gray, Color.gray, Color.gray]//getcolorArr
    
    var body: some View {
        HStack {
            SubejctGradeIcon(color: subColor(), grade: 11)
            Text(subject.name)
            Spacer()
            HStack{
                Text("11").foregroundColor(colors[0])
                Text("11").foregroundColor(colors[1])
                Text("11").foregroundColor(colors[2])
                Text("11").foregroundColor(colors[3])
            }
        }.onAppear{
            getcolorArr()
        }
    }
    
    func getcolorArr(){
        let inactiveYears = getinactiveYears(subject)
        inactiveYears.forEach { year in
            if(year.isEmpty){return}
            colors[Int(year)! - 1] = Color.red
        }
        
    }
    
    func subColor() -> Color{
        if(settings.colorfulCharts) {
            let index = subjects.firstIndex(where: {$0.objectID == subject.objectID}) ?? 0
            return  getPastelColorByIndex(index)
        }
        return Color(hexString: subject.color)
    }
}


struct SubejctGradeIcon: View {
    @State var color: Color
    @State var grade: Int
    var body: some View {
        ZStack{
            RoundedRectangle(cornerRadius: 8).fill(color).frame(width: 30, height: 30)
            Text(String(grade))
        }
    }
}

struct SummaryCell: View {
    @State var inActiveYears: Int
    @State var activeMax: Int
    
    var body: some View {
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(width: 30, height: 30)
                Text("∑")
            }
            Text("\(activeMax - inActiveYears) von \(activeMax) aktiv")
        }
    }
}
