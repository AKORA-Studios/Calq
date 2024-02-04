//
//  SettingsScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SettingsScreen: View {
    @ObservedObject var vm: SettingsViewModel
    @EnvironmentObject var tabBarVM: TabVM
    
    var body: some View {
        NavigationView {
            List {
                staticCells()
                
                dynamicCells()
                
                Section {
                    Text("Version: \(appVersion) Build: \(buildVersion)").foregroundColor(.gray)
                }
                
                backupCells()
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
        }.navigationViewStyle(StackNavigationViewStyle())
        
            .sheet(isPresented: $vm.editSubjectPresented) {
                NavigationView {
                    if let selectedSubject = vm.selectedSubjet {
                        EditSubjectScreen(vm: EditSubjectViewModel(subject: selectedSubject), editSubjectPresented: $vm.editSubjectPresented).onDisappear(perform: vm.reloadAndSave)
                    }
                }
            }
            .sheet(isPresented: $vm.showFeedbackSheet, content: {
                feeedbackSheet()
            })
            .alert(isPresented: $vm.deleteAlert) {
                settingsAlert()
            }
            .onAppear(perform: vm.onAppear)
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
            HStack {
                SettingsIcon(color: Color(hexString: "5856d6"), icon: "books.vertical.fill", text: "settingsExamCount") {}
                Spacer()
                Picker("", selection: $vm.hasFiveExams) {
                    Text("4").tag(4)
                    Text("5").tag(5)
                }.pickerStyle(.segmented)
                    .onChange(of: vm.hasFiveExams) { _ in
                        vm.updateExamSettings()
                    }
                    .frame(width: 70)
            }
            
            HStack {
                SettingsIcon(color: Color.calqColor, icon: "chart.bar.fill", text: "settingsRainbow") {}
                Toggle(isOn: $vm.settings.colorfulCharts) {}.onChange(of: vm.settings.colorfulCharts) { _ in
                    vm.updateColorfulCharts()
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
            
            SettingsIcon(color: Color.pink, icon: "info.circle.fill", text: "Github", completation: {
                if let url = URL(string: "https://github.com/AKORA-Studios/Calq") {
                    UIApplication.shared.open(url)
                }
            })
            
            /* SettingsIcon(color: Color(hexString: "c14f9f"), icon: "bubble.right.fill", text: "settings.feedback.title") {
             vm.showFeedbackSheet = true
             }*/
        }
    }
    
    func dynamicCells() -> some View {
        Section(header: Text("settingsSection2")) {
            
            ForEach(vm.subjects) { sub in
                SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name, completation: {
                    vm.selectSubject(sub)
                })
                .contextMenu {
                    contextAction_addGradeButton()
                    contextAction_addExamButton()
                    contextAction_adeleteSubjectButton(sub)
                }
            }
            
            SettingsIcon(color: .green, icon: "plus", text: "newSub") {
                vm.newSubjectSheetPresented = true
            }
        }
    }
    
    func backupCells() -> some View {
        Section(header: Text("backupSheet.section")) {
            ForEach(JSON.loadBackups(), id: \.self) { url in
                NavigationLink {
                    ScrollView {
                        Text(JSON.loadBackup(url: url))
                    }.padding(.horizontal)
                        .navigationTitle(JSON.parseFileName(url))
                } label: {
                    Text(JSON.parseFileName(url))
                } .swipeActions {
                    Button("backupSheet.delete") {
                        JSON.deleteBackup(url)
                        vm.backups = JSON.loadBackups()
                    }
                    .tint(.red)
                    Button("backupSheet.load") {
                        JSON.importWithstringURL(url)
                        vm.reloadAndSave()
                    }
                }
            }
        }
    }
    
    func contextAction_addGradeButton() -> some View {
        Button {
            tabBarVM.selectedIndex = 2
        } label: {
            Label("gradeNewAdd", systemImage: "plus")
        }
    }
    
    func contextAction_addExamButton() -> some View {
        Button {
            tabBarVM.selectedIndex = 3
        } label: {
            Label("ExamViewSubSelect", systemImage: "book.closed")
        }
    }
    
    @ViewBuilder
    func contextAction_adeleteSubjectButton(_ sub: UserSubject) -> some View {
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
    
    func feeedbackSheet() -> some View {
        VStack {
            Text("settings.feedback.title")
                .font(.headline)
            
            if vm.feedbackError {
                Text("settings.feedback.error")
                    .foregroundColor(.red)
            }
            
            TextEditor(text: $vm.feedbackContent)
                .multilineTextAlignment(.leading)
                .background(Color.gray.opacity(0.3))
                .cornerRadius(8)
                .frame(minHeight: 50)
                .shadow(radius: 5)
            
            Text("\(vm.feedbackContent.count)settings.feedback.textlimit")
                .foregroundColor(vm.feedbackContent.count >= 1000 ? .red : .gray)
                .font(.footnote)
            
            Button("settings.feedback.button", action: {
                vm.sendFeedback()
            }).disabled(vm.feedbackContent.count >= 1000)
                .buttonStyle(PrimaryStyle())
        }.padding()
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
            Spacer()
        }
        .frame(height: 30, alignment: .leading)
        .frame(maxWidth: .infinity)
        .contentShape(Rectangle())
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
