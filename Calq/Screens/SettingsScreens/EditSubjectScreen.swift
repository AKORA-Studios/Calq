//
//  EditSubjectScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

enum EditAlertType {
    case delete
    case nameInvalid
}

struct EditSubjectScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @Binding var editSubjectPresented: Bool
    
    @Binding var subject: UserSubject?
    @State var subjectName = ""
    @State var lkSubject = 0
    @State var selectedColor: Color = .accentColor
    
    @State var deleteAlert = false
    @State var alertType: EditAlertType = .nameInvalid
    
    var body: some View {
        if subject != nil {
            let color = getSubjectColor(subject!)
            VStack {
                ZStack {
                    VStack(alignment: .leading) {
                        Text("subjectName")
                        TextField("name", text: $subjectName)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: subjectName) { _ in
                            if Util.isStringInputInvalid(subjectName) {
                                alertType = .nameInvalid
                                subjectName = subject!.name
                                deleteAlert = true
                            } else {
                                subject?.name = subjectName
                                saveCoreData()
                            }
                        }
                    }.padding()
                }.background(CardView())
                
                ZStack {
                    VStack(alignment: .leading) {
                        Text("subjectType")
                        Picker("subjectType", selection: $lkSubject) {
                            Text("typeGK").tag(0)
                            Text("typeLK").tag(1)
                        }.pickerStyle(.segmented)
                            .colorMultiply(color)
                            .onChange(of: lkSubject) { _ in
                                subject!.lk = lkSubject == 1 ? true : false
                                saveCoreData()
                            }
                    }.padding()
                }.background(CardView())
                
                ZStack {
                        HStack {
                            Image(systemName: "paintpalette")
                            Text("editSubColor")
                            
                            ColorPicker("", selection: $selectedColor, supportsOpacity: false).onChange(of: selectedColor) { _ in
                                subject!.color = UIColor(selectedColor).toHexString()
                                saveCoreData()
                            }
                        }
                    .padding()
                }.background(CardView())
                
            infoTexts()
                
                VStack {
                    NavigationLink(destination: GradeListScreen(subject: subject!)) {
                        Text("editSubGrades").foregroundColor(.white)
                    }.buttonStyle(PrimaryStyle())
                    
                    Button("editSubDelete") {
                        alertType = .delete
                        deleteAlert = true
                    }.buttonStyle(DestructiveStyle())
                }
            }.alert(isPresented: $deleteAlert) {
                switch alertType {
                    
                case .delete:
                    return Alert(title: Text("ToastTitle"), message: Text("ToastDesc"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastDelete"), action: {
                        editSubjectPresented = false
                        Util.deleteSubject(subject!)
                        subject = nil
                    }))
                case .nameInvalid:
                    return Alert(title: Text("editSubjectNameInvalid"), message: Text("editSubjecNameInvalidChars"))
                }
            }
            .padding()
            .navigationTitle("editSubject")
            .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
            .onAppear {
                subjectName = subject!.name
                lkSubject = subject!.lk ? 1 : 0
                selectedColor = Color(hexString: subject!.color)
            }
        }
    }
    
    @ViewBuilder
    func infoTexts() -> some View {
        ZStack {
         //   CardView().frame(height:  30)
            VStack {
                HStack {
                    Image(systemName: "info.circle")
                    Text("editSubGradeCount\(subject!.subjecttests?.count ?? 0)")
                }
                if Util.isExamSubject(subject!) {
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
