//
//  EditSubjectScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

enum editAlertType {
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
    @State var alertType: editAlertType = .nameInvalid
    
    var body: some View{
        if(subject != nil) {
            let color = Color(hexString: subject!.color)
            VStack{
                ZStack{
                    VStack(alignment: .leading){
                        Text("subjectName")
                        TextField("name", text: $subjectName)
                            .textFieldStyle(.roundedBorder)
                            .onChange(of: subjectName) { _ in
                            if(Util.checkString(subjectName)){
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
                
                ZStack{
                    VStack(alignment: .leading){
                        Text("subjectType")
                        Picker("subjectType", selection: $lkSubject) {
                            Text("typeGK").tag(0)
                            Text("typeLK").tag(1)
                        }.pickerStyle(.segmented)
                            .colorMultiply(color)
                            .onChange(of: lkSubject) { newValue in
                                subject!.lk = lkSubject == 1 ? true : false
                                saveCoreData()
                            }
                    }.padding()
                }.background(CardView())
                
                ZStack{
                        HStack{
                            Image(systemName: "paintpalette")
                            Text("editSubColor")
                            
                            ColorPicker("", selection: $selectedColor, supportsOpacity: false).onChange(of: selectedColor) { newValue in
                                subject!.color = UIColor(selectedColor).toHexString()
                                saveCoreData()
                            }
                        }
                    .padding()
                }.background(CardView())
                    .padding(.bottom, 40)
                
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
                    return Alert(title: Text("ToastTitle"), message: Text("ToastDesc"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastDelete"),action: {
                        editSubjectPresented = false
                        Util.deleteSubject(subject!)
                        subject = nil
                    }))
                case .nameInvalid: //TODO: chekc if right???
                    return Alert(title: Text("editSubjectNameInvalid"), message: Text("editSubjecNameInvalidChars"))
                }
            }
            .padding()
            .navigationTitle("editSubject")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .onAppear{
                subjectName = subject!.name
                lkSubject = subject!.lk ? 1 : 0
                selectedColor = color
            }
        }
    }
    
    func dismissSheet(){
            saveCoreData()
            self.presentationMode.wrappedValue.dismiss()
    }
}
