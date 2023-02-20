//
//  SubjectListScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SubjectlistData: Hashable{
    var subject: UserSubject
    var yearString: [String]
    var colors: [Color]
}

struct SubjectListScreen: View {
    @State var subjects: [UserSubject] = []
    @State var selectedSubejct: UserSubject?
    
    @State var gradeTablePresented = false
    @State var isSubjectDetailPResented = false
    
    @State var inactiveCount = 0
    @State var subjectCount = 0
    
    @State var data: [SubjectlistData] = []
    
    var body: some View {
        NavigationView{
            List{
                Section{
                    ForEach(data, id: \.self){entry in
                        HStack{
                            let color = getSubjectColor(entry.subject)
                            let average = Util.testAverage(Util.filterTests(entry.subject))
                            
                            ZStack{
                                RoundedRectangle(cornerRadius: 8).fill(color).frame(width: 30, height: 30)
                                Text(String(format: "%.0f", round(average)))
                            }
                            Text(entry.subject.name)
                            
                            Spacer()
                            
                            HStack{
                                ForEach(0...3, id: \.self) { i in
                                    Text(entry.yearString[i]).foregroundColor(entry.colors[i]).frame(width: 25)
                                }
                            }
                        }
                        .onTapGesture {
                            selectedSubejct = entry.subject
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
                    data = []
                    subjects.forEach { sub in
                        data.append(SubjectlistData(subject: sub, yearString: setAverages(subject: sub), colors: getcolorArr(subject: sub)))
                    }
                    update()
                }
        }
    }
    
    func update(){
        subjects = Util.getAllSubjects()
        inactiveCount = (subjects.count * 4) - calcInactiveYearsCount()
        subjectCount = subjects.count * 4
    }
    
    func calcInactiveYearsCount()-> Int{
        if(subjects.count == 0) {return 0}
        var count: Int = 0
        
        for sub in subjects {
            let arr = Util.getinactiveYears(sub)
            for num in arr {
                if(num == "") {continue}
                if Int(num) != nil { count += 1}
            }
        }
        return count
    }
    
    func setAverages(subject: UserSubject) -> [String]{
        var arr = ["-","-","-","-"]
        for i in 0...3{
            arr[i] = String(format: "%.0f", Util.getSubjectAverage(subject, year: i+1, filterinactve: false))
        }
        return arr
    }
    
    func getcolorArr(subject: UserSubject) -> [Color]{
        var arr = [Color.gray, Color.gray, Color.gray, Color.gray, Color.gray]
        let inactiveYears = Util.getinactiveYears(subject)
        //  print(subject.name, inactiveYears)
        inactiveYears.forEach { year in
            if(year.isEmpty){return}
            arr[Int(year)! - 1] = Color.red
        }
        return arr
    }
}
