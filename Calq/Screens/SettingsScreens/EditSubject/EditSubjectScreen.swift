//
//  EditSubjectScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct EditSubjectScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: EditSubjectViewModel
    
    @Binding var editSubjectPresented: Bool
    
    var body: some View {
        let color = getSubjectColor(vm.subject)
        VStack {
            CardContainer {
                VStack(alignment: .leading) {
                    Text("subjectName")
                    TextField("name", text: $vm.subjectName)
                        .textFieldStyle(.roundedBorder)
                        .onChange(of: vm.subjectName) { _ in
                            vm.changeName()
                        }
                }
            }
            
            CardContainer {
                VStack(alignment: .leading) {
                    Text("subjectType")
                    Picker("subjectType", selection: $vm.lkSubject) {
                        Text("typeGK").tag(0)
                        Text("typeLK").tag(1)
                    }.pickerStyle(.segmented)
                        .colorMultiply(color)
                        .onChange(of: vm.lkSubject) { _ in
                            vm.changeType()
                        }
                }
            }
            
            CardContainer {
                HStack {
                    Image(systemName: "paintpalette")
                    Text("editSubColor")
                    
                    ColorPicker("", selection: $vm.selectedColor, supportsOpacity: false).onChange(of: vm.selectedColor) { _ in
                        vm.changeColor()
                    }
                }
            }
            
            infoTexts()
            
            VStack {
                if vm.hasTest {
                    NavigationLink(destination: GradeListScreen(vm: GradeListViewModel(subject: vm.subject))) {
                        Text("editSubGrades").foregroundColor(.white)
                    }.buttonStyle(PrimaryStyle())
                }
                
                Button("editSubDelete") {
                    vm.showDeleteSubject()
                }.buttonStyle(DestructiveStyle())
            }
        }.alert(isPresented: $vm.deleteAlert) {
            switch vm.alertType {
                
            case .delete:
                return Alert(title: Text("ToastTitle"), message: Text("ToastDesc"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastDelete"), action: {
                    vm.deleteSubject()
                    editSubjectPresented = false
                }))
            case .nameInvalid:
                return Alert(title: Text("editSubjectNameInvalid"), message: Text("editSubjecNameInvalidChars"))
            }
        }
        .padding()
        .navigationTitle("editSubject")
        .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
        .onAppear {
            vm.update()
        }
    }
    
    @ViewBuilder
    func infoTexts() -> some View {
        ZStack {
            //   CardView().frame(height:  30)
            VStack {
                HStack {
                    Image(systemName: "info.circle")
                    Text("editSubGradeCount\(vm.subject.subjecttests?.count ?? 0)")
                }
                if Util.isExamSubject(vm.subject) {
                    HStack {
                        Image(systemName: "info.circle")
                        Text("editSubInfoIsExam")
                    }
                }
            }
            
        }.padding(.bottom, 40)
    }
    
    func dismissSheet() {
        saveCoreData()
        self.presentationMode.wrappedValue.dismiss()
    }
}
