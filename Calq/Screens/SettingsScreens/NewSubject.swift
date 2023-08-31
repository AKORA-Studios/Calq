//
//  NewSubject.swift
//  Calq
//
//  Created by Kiara on 15.02.23.
//

import SwiftUI

struct NewSubjectScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var subjectName = ""
    @State var lkSubject = 0
    @State var selectedColor: Color = .accentColor
    
    @State var nameAlert = false
    @State var alertMessage = ""
    
    var body: some View {
        VStack {
            CardContainer {
                VStack(alignment: .leading) {
                    Text("subjectName")
                    TextField("name", text: $subjectName)
                        .textFieldStyle(.roundedBorder)
                }
            }
            
            CardContainer {
                VStack(alignment: .leading) {
                    Text("subjectType")
                    Picker("subjectType", selection: $lkSubject) {
                        Text("typeGK").tag(0)
                        Text("typeLK").tag(1)
                    }.pickerStyle(.segmented)
                        .colorMultiply(selectedColor)
                }
            }
            
            CardContainer {
                HStack {
                    Text("editSubColor")
                    Image(systemName: "paintpalette")
                    ColorPicker("", selection: $selectedColor, supportsOpacity: false)
                }
            }
            
            Button("saveData") {
                if Util.isStringInputInvalid(subjectName) {
                    alertMessage = "editSubjecNameInvalidChars"
                    nameAlert = true
                } else {
                    addSubject()
                }
            }.buttonStyle(PrimaryStyle())
                .accessibilityIdentifier(Ident.NewSubject.saveButton)
            
        }.navigationTitle("newSub")
            .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
            .alert(isPresented: $nameAlert) {
                Alert(title: Text("editSubjectNameInvalid"), message: Text(LocalizedStringKey(alertMessage)))
            }
            .padding()
    }
    
    func addSubject() {
        let subject = UserSubject(context: Util.getContext())
        subject.color = UIColor(selectedColor).toHexString()
        subject.name = subjectName
        subject.lk = lkSubject == 1
        
        let settings = Util.getSettings()
        settings.addToUsersubjects(subject)
        
        saveCoreData()
        dismissSheet()
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
