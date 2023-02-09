//
//  SettingsScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.managedObjectContext) var coreDataContext
    @StateObject var settings: AppSettings = getSettings()!
    @State var subjects: [UserSubject] = getAllSubjects()
    
    @State var presentDocumentPicker = false
    @State var importedJson: String = ""
    @State var importeJsonURL: URL = URL(fileURLWithPath: "")
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("General")){
                    SettingsIcon(color: Color.blue, icon: "info.circle.fill", text: "Github")
                        .onTapGesture {
                            if let url = URL(string: "https://github.com/AKORA-Studios/Calq") {
                                UIApplication.shared.open(url)
                            }
                        }
                    
                    HStack {
                        SettingsIcon(color: Color.blue, icon: "chart.bar.fill", text: "Regenbogen")
                        Toggle(isOn: $settings.colorfulCharts){}.onChange(of: settings.colorfulCharts) { newValue in
                            reloadAndSave()
                        }
                    }
                    
                    SettingsIcon(color: Color.blue, icon: "folder.fill", text: "Noten importieren")
                        .onTapGesture {
                            presentDocumentPicker = true
                            //TODO: w
                        }
                    
                    SettingsIcon(color: Color.blue, icon: "square.and.arrow.up.fill", text: "noten exportieren")
                        .onTapGesture {
                            let data = JSON.exportJSON()
                            let url = JSON.writeJSON(data)
                            showShareSheet(url: url)
                        }
                    
                    SettingsIcon(color: Color.yellow, icon: "square.stack.3d.down.right.fill", text: "wertung ändern")
                        .onTapGesture {
                            print("wertung ändern") //TODO: w
                        }
                    
                    SettingsIcon(color: Color.orange, icon: "exclamationmark.triangle.fill", text: "Load demo data")
                        .onTapGesture {
                            JSON.loadDemoData()
                            reloadAndSave()
                        }
                    
                    SettingsIcon(color: Color.blue, icon: "trash.fill", text: "daten löschen")
                        .onTapGesture {
                            _ = Util.deleteSettings()
                            subjects = []
                            reloadAndSave()
                        }
                }
                Section(header: Text("Subjects")){
                  
                    ForEach(subjects) { sub in
                        subjectView(sub)
                    }
                    
                    SettingsIcon(color: .green, icon: "plus", text: "neues Fach")
                }
                
                Section(){
                    Text("Version: \(appVersion ?? "0.0.0")").foregroundColor(.gray)
                }
            }.navigationTitle("Einstellungen")
                .sheet(isPresented: $presentDocumentPicker) {
                    DocumentPicker(fileURL: $importeJsonURL).onDisappear{ reloadAndSave()}
                }
        }
    }
    
    func reloadAndSave(){
        saveCoreData()
        subjects = getAllSubjects()
        settings.colorfulCharts = getSettings()!.colorfulCharts
    }
    
    @ViewBuilder
    func subjectView(_ sub: UserSubject) -> SettingsIcon {
        let index = 1
        SettingsIcon(color: settings.colorfulCharts ? getPastelColorByIndex(subjects.firstIndex(where: {$0.objectID == sub.objectID})!) : Color(hexString: sub.color), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name)
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




