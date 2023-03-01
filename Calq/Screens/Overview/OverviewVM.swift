//
//  OverviewVM.swift
//  Calq
//
//  Created by Kiara on 01.03.23.
//

import Foundation


class OverViewViewModel: ObservableObject {
    @Published var subjects: [UserSubject] = []
    
    func updateViews(){
        self.objectWillChange.send()
        subjects = Util.getAllSubjects()
    }
}
