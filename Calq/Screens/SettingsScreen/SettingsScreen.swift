//
//  SettingsScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SettingsScreen: View {//TODO: kinda fix load demo data
    @ObservedObject var vm: SettingsViewModel
    
    var body: some View {
        NavigationView {
            List{
                Section(header: Text("Allgemein")){
                    SettingsIcon(color: Color.purple, icon: "info.circle.fill", text: "Github", completation: {
                        if let url = URL(string: "https://github.com/AKORA-Studios/Calq") {
                            UIApplication.shared.open(url)
                        }
                    })
                    
                    HStack {
                        SettingsIcon(color: Color.accentColor, icon: "chart.bar.fill", text: "Regenbogen", completation: {})
                        Toggle(isOn: $vm.settings.colorfulCharts){}.onChange(of: vm.settings.colorfulCharts) { newValue in
                            vm.reloadAndSave()
                        }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                    }
                    
                    SettingsIcon(color: Color.blue, icon: "folder.fill", text: "Noten importieren", completation: {
                        vm.alertActiontype = .importData
                        vm.deleteAlert = true
                    })
                    
                    SettingsIcon(color: Color.green, icon: "square.and.arrow.up.fill", text: "Noten exportieren", completation: {
                        let data = JSON.exportJSON()
                        let url = JSON.writeJSON(data)
                        showShareSheet(url: url)
                    })
                    
                    SettingsIcon(color: Color.yellow, icon: "square.stack.3d.down.right.fill", text: "Wertung ändern", completation: {
                        vm.weightSheetPresented = true
                    })
                    
                    SettingsIcon(color: Color.orange, icon: "exclamationmark.triangle.fill", text: "Demo Daten laden", completation: {
                        vm.alertActiontype = .loadDemo
                        vm.deleteAlert = true
                    })
                    
                    SettingsIcon(color: Color.red, icon: "trash.fill", text: "Daten löschen", completation: {
                        vm.alertActiontype = .deleteData
                        vm.deleteAlert = true
                    })
                }
                Section(header: Text("Fächer")){
                    
                    ForEach(vm.subjects) { sub in
                        subjectView(sub)
                    }
                    
                    SettingsIcon(color: .green, icon: "plus", text: "Neues Fach", completation: {
                        vm.newSubjectSheetPresented = true
                    })
                }
                
                Section(){
                    Text("Version: \(appVersion ?? "0.0.0")").foregroundColor(.gray)
                }
            }.navigationTitle("Einstellungen")
                .sheet(isPresented: $vm.presentDocumentPicker) {
                    DocumentPicker(fileURL: $vm.importeJsonURL).onDisappear{ vm.reloadAndSave()}
                }
                .sheet(isPresented: $vm.weightSheetPresented) {
                    NavigationView {
                        ChangeWeightScreen()
                    }
                }
                .sheet(isPresented: $vm.newSubjectSheetPresented) {
                    NavigationView {
                        NewSubjectScreen().onDisappear(perform: vm.reloadAndSave)
                    }
                }
        }
        .sheet(isPresented: $vm.editSubjectPresented) {
            NavigationView {
                EditSubjectScreen(editSubjectPresented: $vm.editSubjectPresented, subject: $vm.selectedSubjet).onDisappear(perform: vm.reloadAndSave)
            }
        }
        .alert(isPresented: $vm.deleteAlert) {
            Alert(title: Text("Sicher?"), message: Text("Alle deine Daten werden gelöscht"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Oki"),action: {
                switch vm.alertActiontype {
                    
                case .importData:
                    vm.presentDocumentPicker = true
                case .deleteData:
                    vm.deleteData()
                case .loadDemo:
                    JSON.loadDemoData()
                    vm.reloadAndSave()
                case .none:
                    break
                }
                vm.alertActiontype = .none
                vm.deleteAlert = false
            }
                                                                                                                                                    ))
        }
        .onAppear{
            vm.subjects = Util.getAllSubjects()
        }
    }
    
    @ViewBuilder
    func subjectView(_ sub: UserSubject) -> SettingsIcon {
        SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name, completation: {
            vm.editSubjectPresented = true
            vm.selectedSubjet = sub
        })
    }
}

struct SettingsIcon: View {
    var color: Color
    var icon: String
    var text: String
    var completation:  () -> Void
    
    var body: some View {
        GeometryReader { geo in
            HStack{
                ZStack {
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(color)
                        .frame(width: 30, height: 30)
                    Image(systemName: icon)
                        .foregroundColor(.white)
                }
                Text(text)
            }
            .frame(width: geo.size.width, height: 30, alignment: .leading)
            .onTapGesture {
                completation()
            }
        }
    }
}

struct SettingsPreview: PreviewProvider {
    static var previews: some View {
        SettingsScreen(vm: SettingsViewModel())
    }
}
