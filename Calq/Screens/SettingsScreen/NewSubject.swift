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
        VStack{
            ZStack{
                VStack(alignment: .leading){
                    Text("Kursname")
                    TextField("Name", text: $subjectName)
                }.padding()
            }.background(CardView())
            
            ZStack{
                VStack(alignment: .leading){
                    Text("Typ")
                    Picker("Typ", selection: $lkSubject) {
                        Text("Grundkurs").tag(0)
                        Text("Leistungskurs").tag(1)
                    }.pickerStyle(.segmented)
                        .colorMultiply(selectedColor)
                }.padding()
            }.background(CardView())
            
            ZStack{
                VStack(alignment: .leading){
                    Text("Kursfarbe")
                    
                    HStack{
                        Image(systemName: "paintpalette")
                        ColorPicker("Farbe ändern", selection: $selectedColor, supportsOpacity: false)
                    }
                }.padding()
            }.background(CardView())
            
            Button("Speichern") {
                if(subjectName.isEmpty){
                    alertMessage = "Name darf nicht leer sein"
                    nameAlert = true
                } else if (Util.checkString(subjectName)){
                    alertMessage = "Name darf keine Sonderzeichen/Zahlen etc. enthalten"
                    nameAlert = true
                }else {
                    addSubject()
                }
            }.buttonStyle(PrimaryStyle())
            
        }.navigationTitle("Neues Fach")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .alert(isPresented: $nameAlert) {
                Alert(title: Text("Name ungültig"), message: Text(alertMessage))
            }
            .padding()
    }
    
    func addSubject(){
        let subject = UserSubject(context: context)
        subject.color = UIColor(selectedColor).toHexString()
        subject.name = subjectName
        subject.lk = lkSubject == 1
        
        let settings = Util.getSettings()
        settings!.addToUsersubjects(subject)
        
        saveCoreData()
        dismissSheet()
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}
