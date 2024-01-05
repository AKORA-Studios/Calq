//
//  GradeListViewModel.swift
//  Calq
//
//  Created by Kiara on 13.12.23.
//

import Foundation

class GradeListViewModel: ObservableObject {
    @Published var subject: UserSubject
    @Published var years: [[UserTest]] = [[], [], [], []]
    @Published var Alltests: [UserTest] = []
    @Published var deleteAlert = false
    
    init(subject: UserSubject) {
        self.subject = subject
        update()
    }
    
    func update() {
        let Alltests = (subject.subjecttests ?? []).sorted(by: {$0.date < $1.date})
        
        years[0] = Alltests.filter {$0.year == 1}
        years[1] = Alltests.filter {$0.year == 2}
        years[2] = Alltests.filter {$0.year == 3}
        years[3] = Alltests.filter {$0.year == 4}
    }
    
    func deleteAction() {
        subject.subjecttests = [] // TODO: not sure if thats allright?
        saveCoreData()
    }
    
    func formatDate(date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yy"
        return dateFormatter.string(from: date)
    }
}
