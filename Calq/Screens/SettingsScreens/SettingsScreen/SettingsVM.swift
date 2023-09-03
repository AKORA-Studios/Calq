//
//  SettingsVM.swift
//  Calq
//
//  Created by Kiara on 16.03.23.
//

import Foundation

enum AlertAction {
    case importData
    case deleteData
    case deleteSubject
    case loadDemo
    case none
}

class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings = Util.getSettings()
    @Published var subjects: [UserSubject] = Util.getAllSubjects()
    @Published var selectedSubjet: UserSubject?
    
    @Published var hasFiveExams = Util.getSettings().hasFiveExams ? 5 : 4
    
    // sheet presnet stuff
    @Published var editSubjectPresented = false
    @Published var weightSheetPresented = false
    @Published var newSubjectSheetPresented = false
    @Published var presentDocumentPicker = false
    
    @Published var deleteAlert = false
    @Published var alertActiontype: AlertAction = .none
    
    @Published var isLoading = false
    
    // import&export
    @Published var importedJson: String = ""
    @Published var importeJsonURL: URL = URL(fileURLWithPath: "")
    
    func reloadAndSave() {
        subjects = Util.getAllSubjects()
        settings = Util.getSettings()
    }
    
    func deleteData() {
        Util.deleteSettings()
        subjects = []
        reloadAndSave()
    }
    
    func showDeleteSubAlert(_ sub: UserSubject) {
        selectedSubjet = sub
        alertActiontype = .deleteSubject
        deleteAlert = true
    }
    
    func deleteSubject() {
        guard let sub = selectedSubjet else { return print("Subject not selected")}
        
        Util.deleteSubject(sub)
        alertActiontype = .none
        deleteAlert = false
        reloadAndSave()
    }
    
    func updateColorfulCharts() {
        settings.colorfulCharts = Util.getSettings().colorfulCharts
        saveCoreData()
    }
    
    func updateExamSettings() {
        settings.hasFiveExams = hasFiveExams == 5
        saveCoreData()
    }
}
