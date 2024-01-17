//
//  EditGradeScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct EditGradeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var toastControl: ToastControl
    @ObservedObject var vm: EditGradeViewModel
    var color: Color = .accentColor

    var body: some View {
        ScrollView(showsIndicators: false) {
        VStack {
            CardContainer {
                VStack(alignment: .leading) {
                    Text("gradeName")
                    TextField("gradeName", text: $vm.testName)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            CardContainer {
                VStack(alignment: .leading) {
                    Text("gradeType")
                    Picker("gradeType", selection: $vm.testType) {
                        ForEach(Array(Util.getTypes().enumerated()), id: \.offset) { _, type in
                            Text(type.name).tag(type.id)
                        }
                    }.pickerStyle(.segmented).colorMultiply(color)
                }
            }
            
            CardContainer {
                VStack(alignment: .leading) {
                    Text("gradeHalfyear")
                    Picker("gradeYear", selection: $vm.testYear) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                    }.pickerStyle(.segmented).colorMultiply(color)
                    
                    HStack {
                        DatePicker("gradeDate", selection: $vm.testDate, displayedComponents: [.date])
                    }
                }
            }
            
            CardContainer {
                VStack(alignment: .leading) {
                    Text("gradePoints")
                    HStack {
                        Text(String(Int(vm.testPoints)))
                        Slider(value: $vm.testPoints, in: 0...15, onEditingChanged: { _ in
                            vm.testPoints = vm.testPoints.rounded()
                        })
                        .accentColor(Color.accentColor)
                    }
                }
            }
            
            if vm.shouldShowGradeTypeOptions {
                CardContainer {
                    HStack {
                        Text("gradeIWritten")
                        Spacer()
                        Toggle(isOn: $vm.isWrittenGrade) {}.onChange(of: vm.isWrittenGrade) { _ in
                            vm.test.isWrittenGrade = vm.isWrittenGrade
                        }.toggleStyle(SwitchToggleStyle(tint: .accentColor))
                            .frame(width: 60)
                    }.frame(maxWidth: .infinity)
                }
            }
         
            TimeStampTexts(createdAt: vm.createdAt, lastEditedAt: vm.lastEditedAt)
            
            Button("gradeSave") {
                saveGrade()
            }.buttonStyle(PrimaryStyle())
                .padding(.top, 20)
            
            Button("gradeDelete") {
                vm.deleteAlert = true
            }.buttonStyle(DestructiveStyle())
        }
        }.padding()
            .navigationTitle("gradeEdit")
            .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
         /*   .onAppear {
                vm.update()
            }*/
            .alert(isPresented: $vm.deleteAlert) {
                Alert(title: Text("ToastTitle"), message: Text("ToastDeleteGrade"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastOki"), action: {
                    deleteGrade()
                }))
            }
    }
    
    func deleteGrade() {
        dismissSheet()
        Util.deleteTest(vm.test)
        toastControl.show("gradeEditDelete", .success)
    }
    
    func saveGrade() {
        vm.saveGrade()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
