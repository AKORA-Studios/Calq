//
//  EditSubjectViewModel.swift
//  Calq
//
//  Created by Kiara on 13.12.23.
//

import Foundation
import UIKit
import SwiftUI

enum EditAlertType {
    case delete
    case nameInvalid
}

class EditSubjectViewModel: ObservableObject {
    @Published var subject: UserSubject
    @Published var subjectName = ""
    @Published var lkSubject = 0
    @Published var selectedColor: Color = .accentColor
    
    @Published var deleteAlert = false
    @Published var alertType: EditAlertType = .nameInvalid
    @Published var hasTests = false
    
    @Published var lastEditedAt: Date = Date()
    @Published var createdAt: Date = Date()
    
    init(subject: UserSubject) {
        self.subject = subject
        hasTests = !subject.getAllTests().isEmpty
    }
    
    func update() {
        subjectName = subject.name
        lkSubject = subject.lk ? 1 : 0
        selectedColor = Color(hexString: subject.color)
        hasTests = !subject.getAllTests().isEmpty
    }
    
    func changeName() {
        if Util.isStringInputInvalid(subjectName) {
            alertType = .nameInvalid
            subjectName = subject.name
            deleteAlert = true
        } else {
            subject.name = subjectName
            subject.lastEditedAt = Date()
            saveCoreData()
        }
    }
    
    func changeType() {
        subject.lk = lkSubject == 1 ? true : false
        subject.lastEditedAt = Date()
        saveCoreData()
    }
    
    func changeColor() {
        subject.color = UIColor(selectedColor).toHexString()
        subject.lastEditedAt = Date()
        saveCoreData()
    }
    
    func showDeleteSubject() {
        alertType = .delete
        deleteAlert = true
    }
    
    func deleteSubject() {
        Util.deleteSubject(subject)
    }
}
