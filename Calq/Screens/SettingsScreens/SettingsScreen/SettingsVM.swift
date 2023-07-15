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
    case loadDemo
    case none
}

class SettingsViewModel: ObservableObject {
    @Published var settings: AppSettings = Util.getSettings()
    @Published var subjects: [UserSubject] = Util.getAllSubjects()
    @Published var selectedSubjet: UserSubject?
    
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
        settings.colorfulCharts = Util.getSettings().colorfulCharts
        saveCoreData()
        subjects = Util.getAllSubjects()
        settings = Util.getSettings()
    }
    
    func deleteData() {
        Util.deleteSettings()
        subjects = []
        reloadAndSave()
    }
}
