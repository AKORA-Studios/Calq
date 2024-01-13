//
//  GradeTableOverviewScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct GradeTableOverviewScreen: View {
    @Environment(\.presentationMode) var presentationMode
    var subjects: [UserSubject]
    
    var body: some View {
        VStack {
            if subjects.isEmpty {
                Text("ToastNoSubjects")
            }
            List {
                ForEach(subjects) { sub in
                    gradeTableCell(subject: sub)
                }
            }
        }.navigationTitle("subjectListTable")
            .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
}

struct gradeTableCell: View {
    let subject: UserSubject
    @State var averageString = ["-", "-", "-", "-", "#"]
    
    var body: some View {
        HStack {
            if subject.lk {
                Text(subject.name).foregroundColor(.calqColor )
            } else {
                Text(subject.name)
            }
            Spacer()
            HStack {
                Text(averageString[0]).frame(width: 25)
                Text(averageString[1]).frame(width: 25)
                Text(averageString[2]).frame(width: 25)
                Text(averageString[3]).frame(width: 25)
                Text(" | ").frame(width: 10).foregroundColor(.gray)
                Text(averageString[4]).frame(width: 25).foregroundColor(.calqColor)
            }
        }.onAppear {
            averageString = getString()
        }
    }
    
    /// Generates a convient String that shows the grades of the subject.
    private func getString() -> [String] {
        var str = averageString
        let tests = Util.getAllSubjectTests(subject)
        var sum = 0
        
        for i in 0...3 {
            let arr = tests.filter({$0.year == i+1})
            if arr.count == 0 { continue }
            
            if !Util.checkinactiveYears(Util.getinactiveYears(subject), i+1) { continue }
            let points = Int(round(Util.testAverage(arr)))
            
            str[i] = String(points)
            sum += points
        }
        str[4] = String(subject.lk ? sum*2 : sum)
        return str
    }
}
