//
//  SettingsScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var vm: SettingsViewModel
    
    var body: some View {
        NavigationView {
            List {
                staticCells()
                
                dynamicCells()
                
                Section {
                    Text("Version: \(appVersion) Build: \(buildVersion)").foregroundColor(.gray)
                }
            }
            
            .disabled(vm.isLoading)
            .navigationTitle("settingsTitle")
            .sheet(isPresented: $vm.presentDocumentPicker) {
                DocumentPicker(fileURL: $vm.importeJsonURL).onDisappear {vm.reloadAndSave()}
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
            settingsAlert()
        }
        .onAppear {
            vm.subjects = Util.getAllSubjects()
        }
    }

    func settingsAlert() -> Alert {
        if vm.alertActiontype == .deleteSubject {
            return Alert(title: Text("ToastTitle"), message: Text("ToastDeleteSubject"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastOki"), action: {
                vm.deleteSubject()
            }))
        }
        
        // handle other cases
        return Alert(title: Text("ToastTitle"), message: Text("ToastDeleteAll"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastOki"), action: {
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
            case .deleteSubject: // handled seperatly
                break
            }
            vm.alertActiontype = .none
            vm.deleteAlert = false
        }))
    }
    
    func staticCells() -> some View {
        Section(header: Text("settingsSection1")) {
            SettingsIcon(color: Color.purple, icon: "info.circle.fill", text: "Github", completation: {
                if let url = URL(string: "https://github.com/AKORA-Studios/Calq") {
                    UIApplication.shared.open(url)
                }
            })
            
            HStack {
                SettingsIcon(color: Color.accentColor, icon: "chart.bar.fill", text: "settingsRainbow") {}
                Toggle(isOn: $vm.settings.colorfulCharts) {}.onChange(of: vm.settings.colorfulCharts) { _ in
                    vm.reloadAndSave()
                }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
            }
            
            SettingsIcon(color: Color.blue, icon: "folder.fill", text: "settingsImport") {
                vm.alertActiontype = .importData
                vm.deleteAlert = true
            }
            
            SettingsIcon(color: Color.green, icon: "square.and.arrow.up.fill", text: "settingsExport") {
                let data = JSON.exportJSON()
                let url = JSON.writeJSON(data)
                showShareSheet(url: url)
            }
            
            SettingsIcon(color: Color.yellow, icon: "square.stack.3d.down.right.fill", text: "settingsWeight") {
                vm.weightSheetPresented = true
            }
            
            SettingsIcon(color: Color.orange, icon: "exclamationmark.triangle.fill", text: "settingsLoadDemo") {
                vm.alertActiontype = .loadDemo
                vm.deleteAlert = true
            }
            
            SettingsIcon(color: Color.red, icon: "trash.fill", text: "settingsDelete") {
                vm.alertActiontype = .deleteData
                vm.deleteAlert = true
            }
        }
    }
    
    func dynamicCells() -> some View {
        Section(header: Text("settingsSection2")) {
            
            ForEach(vm.subjects) { sub in
                SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name, completation: {
                    vm.editSubjectPresented = true
                    vm.selectedSubjet = sub
                })
                .contextMenu {
                    deleteSubjectButton(sub)
                }
            }
            
            SettingsIcon(color: .green, icon: "plus", text: "newSub") {
                vm.newSubjectSheetPresented = true
            }
        }
    }
    
    @ViewBuilder
    func deleteSubjectButton(_ sub: UserSubject) -> some View {
        if #available(iOS 15.0, *) {
            Button(role: .destructive) {
                vm.showDeleteSubAlert(sub)
            } label: {
                Label("editSubDelete", systemImage: "trash")
            }
        } else {
            Button("editSubDelete") {
                vm.showDeleteSubAlert(sub)
            }.buttonStyle(MenuPickerDestructive())
        }
    }
}

struct SettingsIcon: View {
    var color: Color
    var icon: String
    var text: String
    var completation: () -> Void
    
    var body: some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(color)
                    .frame(width: 30, height: 30)
                Image(systemName: icon)
                    .foregroundColor(.white)
            }
            Text(LocalizedStringKey(text))
        }
        .frame(height: 30, alignment: .leading)
        .onTapGesture {
            completation()
        }
    }
}

struct SettingsPreview: PreviewProvider {
    static var previews: some View {
        SettingsScreen(vm: SettingsViewModel())
    }
}