//
//  SubjectListScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SubjectListScreen: View {
    @State var subjects: [UserSubject] = getAllSubjects()
    @State var selectedSubejct: UserSubject?
    
    @State var gradeTablePresented = false
    @State var isSubjectDetailPResented = false
    
    @State var inactiveCount = 0
    @State var subjectCount = 0
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    ForEach(subjects){sub in
                        SubjectYearCell(subjects: $subjects, subject: Binding.constant(sub)).onTapGesture {
                            selectedSubejct = sub
                            isSubjectDetailPResented = true
                        }
                    }
                }
                Section{
                    HStack{
                        ZStack{
                            RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(width: 30, height: 30)
                            Text("∑")
                        }
                        Text("\(inactiveCount) von \(subjectCount) Halbjahren aktiv")
                    }
                }
            }.navigationTitle("Kursliste")
                .toolbar {
                    Button("Notentabelle") {
                        gradeTablePresented = true
                    }
                }
                .sheet(isPresented: $isSubjectDetailPResented) {
                    NavigationView{
                        SubjectDetailScreen(subject: $selectedSubejct).onDisappear(perform: update)
                    }
                }
                .sheet(isPresented: $gradeTablePresented) {
                    NavigationView{
                        GradeTableOverviewScreen(subjects: subjects)
                    }
                }
                .onAppear{
                    update()
                }
        }
    }
    
    func update(){
        subjects = getAllSubjects()
        inactiveCount = (subjects.count * 4) - calcInactiveYearsCount()
        subjectCount = subjects.count * 4
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
    @Binding var subjects: [UserSubject]
    @Binding var subject: UserSubject
    @State var colors: [Color] = [Color.gray, Color.gray, Color.gray, Color.gray, Color.gray]
    @State var average: Double = 99.9
    @State var averageArr: [String] = ["-","-","-","-"]
    
    var body: some View {
        HStack {
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(getSubjectColor(subject)).frame(width: 30, height: 30)
                Text(String(format: "%.0f", round(average)))
            }
            Text(subject.name)
            Spacer()
            HStack{
                ForEach(0...3, id: \.self) { i in
                    Text(averageArr[i]).foregroundColor(colors[i]).frame(width: 25)
                }
            }
        }.onAppear{
            average = Util.testAverage(filterTests(subject))
            setAverages()
            getcolorArr()
        }
    }
    
    func setAverages(){
        for i in 0...3{
            averageArr[i] = String(format: "%.0f", Util.getSubjectAverage(subject, year: i+1))
        }
    }
    
    func getcolorArr(){
        let inactiveYears = getinactiveYears(subject)
        inactiveYears.forEach { year in
            if(year.isEmpty){return}
            colors[Int(year)! - 1] = Color.red
        }
    }
}
