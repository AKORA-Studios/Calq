//
//  SettingsScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

enum alertAction{
    case importData
    case deleteData
    case loadDemo
    case none
}

struct SettingsScreen: View {//TODO: kinda fix load demo data
    @Environment(\.managedObjectContext) var coreDataContext
    @StateObject var settings: AppSettings = Util.getSettings()!
    @State var subjects: [UserSubject] = Util.getAllSubjects()
    
    @State var editSubjectPresented = false
    @State var selectedSubjet: UserSubject?
    
    @State var weightSheetPresented = false
    
    @State var newSubjectSheetPresented = false
    
    @State var presentDocumentPicker = false
    @State var importedJson: String = ""
    @State var importeJsonURL: URL = URL(fileURLWithPath: "")
    
    @State var deleteAlert = false
    @State var alertActiontype: alertAction = .none
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Allgemein")){
                    SettingsIcon(color: Color.purple, icon: "info.circle.fill", text: "Github")
                        .onTapGesture {
                            if let url = URL(string: "https://github.com/AKORA-Studios/Calq") {
                                UIApplication.shared.open(url)
                            }
                        }
                    
                    HStack {
                        SettingsIcon(color: Color.accentColor, icon: "chart.bar.fill", text: "Regenbogen")
                        Toggle(isOn: $settings.colorfulCharts){}.onChange(of: settings.colorfulCharts) { newValue in
                            reloadAndSave()
                        }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                    
                    SettingsIcon(color: Color.blue, icon: "folder.fill", text: "Noten importieren")
                        .onTapGesture {
                            alertActiontype = .importData
                            deleteAlert = true
                        }
                    
                    SettingsIcon(color: Color.green, icon: "square.and.arrow.up.fill", text: "Noten exportieren")
                        .onTapGesture {
                            let data = JSON.exportJSON()
                            let url = JSON.writeJSON(data)
                            showShareSheet(url: url)
                        }
                    
                    SettingsIcon(color: Color.yellow, icon: "square.stack.3d.down.right.fill", text: "Wertung ändern")
                        .onTapGesture {
                            weightSheetPresented = true
                        }
                    
                    SettingsIcon(color: Color.orange, icon: "exclamationmark.triangle.fill", text: "Demo Daten laden")
                        .onTapGesture {
                            alertActiontype = .loadDemo
                            deleteAlert = true
                        }
                    
                    SettingsIcon(color: Color.red, icon: "trash.fill", text: "Daten löschen")
                        .onTapGesture {
                            alertActiontype = .deleteData
                            deleteAlert = true
                        }
                }
                Section(header: Text("Fächer")){
                    
                    ForEach(subjects) { sub in
                        subjectView(sub).onTapGesture {
                            editSubjectPresented = true
                            selectedSubjet = sub
                        }
                    }
                    
                    SettingsIcon(color: .green, icon: "plus", text: "Neues Fach")
                }
                
                Section(){
                    Text("Version: \(appVersion ?? "0.0.0")").foregroundColor(.gray)
                }
            }.navigationTitle("Einstellungen")
                .sheet(isPresented: $presentDocumentPicker) {
                    DocumentPicker(fileURL: $importeJsonURL).onDisappear{ reloadAndSave()}
                }
                .sheet(isPresented: $weightSheetPresented) {
                    NavigationView {
                    ChangeWeightScreen()
                    }
                }
                .sheet(isPresented: $newSubjectSheetPresented) {
                    NavigationView {
                    NewSubjectScreen()
                    }
                }
                .sheet(isPresented: $editSubjectPresented) {
                    NavigationView {
                        EditSubjectScreen(editSubjectPresented: $editSubjectPresented, subject: $selectedSubjet).onDisappear(perform: reloadAndSave)
                    }
                }
            
        }
        .alert(isPresented: $deleteAlert) {
            Alert(title: Text("Sure? >.>"), message: Text("Alle deine Daten werden gelöscht"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Oki"),action: {
                switch alertActiontype {
                    
                case .importData:
                    presentDocumentPicker = true
                case .deleteData:
                    deleteData()
                case .loadDemo:
                    JSON.loadDemoData()
                    reloadAndSave()
                case .none:
                    break
                }
                alertActiontype = .none
                deleteAlert = false
            }
          ))
        }
        .onAppear{
            subjects = Util.getAllSubjects()
        }
    }
    
    func reloadAndSave(){
        saveCoreData()
        subjects = Util.getAllSubjects()
        settings.colorfulCharts = Util.getSettings()!.colorfulCharts
    }
    
    func deleteData(){
        _ = Util.deleteSettings()
        subjects = []
        reloadAndSave()
    }
    
    @ViewBuilder
    func subjectView(_ sub: UserSubject) -> SettingsIcon {
        SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name)
    }
}

struct SettingsIcon: View {
    var color: Color
    var icon: String
    var text: String
    
    var body: some View {
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8.0).fill(color).frame(width: 30, height: 30)
                Image(systemName: icon).foregroundColor(.white)
            }
            Text(text)
        }
    }
}

struct SettingsPreview: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}
