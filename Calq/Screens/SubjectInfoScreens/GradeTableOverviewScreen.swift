//
//  GradeTableOverviewScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct GradeTableOverviewScreen: View {
    var subjects: [UserSubject]
    
    var body: some View{
        VStack {
            if(subjects.isEmpty){
                Text("keine fächer? :c")
            }
            List {
                ForEach(subjects) { sub in
                    gradeTableCell(subject: sub)
                }
            }
        }.navigationTitle("Notentabelle")
        
    }
}


struct gradeTableCell: View {
    let subject: UserSubject
    @State var averageString = ["-","-","-","-"]
    
    var body: some View {
        HStack{
            Text(subject.name)
            Spacer()
            HStack{
                Text(averageString[0]).frame(width: 25)
                Text(averageString[1]).frame(width: 25)
                Text(averageString[2]).frame(width: 25)
                Text(averageString[3]).frame(width: 25)
            }
        }.onAppear{
            averageString = getString()
        }
    }
    
    /// Generates a convient String that shows the grades of the subject.
    private func getString() -> [String]{
        var str = averageString
        if(subject.subjecttests == nil) {return str}
        let tests = subject.subjecttests!.allObjects as! [UserTest]
        
        for i in 0...3 {
            let arr = tests.filter({$0.year == i+1});//TODO: check if inactive form 0..3 or 1..4
            if(arr.count == 0){continue}
            
            if(!Util.checkinactiveYears(getinactiveYears(subject), i+1)){continue}
            let points = Int(round(Util.testAverage(arr)))
            
            str[i] = String(points)
        }
        return str
    }
}
