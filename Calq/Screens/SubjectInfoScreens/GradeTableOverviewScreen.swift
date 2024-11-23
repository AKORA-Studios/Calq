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
                Text(subject.name).foregroundColor(.calqColor)
            } else {
                Text(subject.name)
            }
            Spacer()
            HStack {
                Text(averageString[0]).frame(width: 25)
                Text(averageString[1]).frame(width: 25)
                Text(averageString[2]).frame(width: 25)
                Text(averageString[3]).frame(width: 25)
                Text(" | ").frame(width: 10)
                    .foregroundColor(.gray)
                Text(averageString[4]).frame(width: 25)
                    .foregroundColor(.calqColor)
            }
        }.onAppear {
            averageString = Util.getSubjectYearString(subject)
        }
    }
}
