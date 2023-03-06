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
                        Text("Kursname")
                        TextField("Name", text: $subjectName).onChange(of: subjectName) { _ in
                            if(Util.checkString(subjectName)){
                                alertType = .nameInvalid
                                subjectName = subject!.name
                                deleteAlert = true
                            }else {
                                subject?.name = subjectName
                                saveCoreData()
                            }
                        }
                    }.padding()
                }.background(CardView())
                
                ZStack{
                    VStack(alignment: .leading){
                        Text("Typ")
                        Picker("Typ", selection: $lkSubject) {
                            Text("Grundkurs").tag(0)
                            Text("Leistungskurs").tag(1)
                        }.pickerStyle(.segmented)
                            .colorMultiply(color)
                            .onChange(of: lkSubject) { newValue in
                                subject!.lk = lkSubject == 1 ? true : false
                                saveCoreData()
                            }
                    }.padding()
                }.background(CardView())
                
                ZStack{
                    VStack(alignment: .leading){
                        Text("Kursfarbe")
                        
                        HStack{
                            Image(systemName: "paintpalette")
                            
                            ColorPicker("Farbe ändern", selection: $selectedColor, supportsOpacity: false).onChange(of: selectedColor) { newValue in
                                subject!.color = UIColor(selectedColor).toHexString()
                                saveCoreData()
                            }
                        }
                    }.padding()
                }.background(CardView())
                
                Spacer().frame(height: 20)
                
                NavigationLink(destination: GradeListScreen(subject: subject!)) {
                        Text("Noten bearbeiten").foregroundColor(.white)
                }.buttonStyle(PrimaryStyle())
                
                Button("Fach löschen") {
                    alertType = .delete
                    deleteAlert = true
                }.buttonStyle(DestructiveStyle())
                
            }.alert(isPresented: $deleteAlert) {
                switch alertType {
                    
                case .delete:
                    return Alert(title: Text("Sicher?"), message: Text("Alle Kursdaten werrden gelöscht"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Löschen"),action: {
                        editSubjectPresented = false
                        Util.deleteSubject(subject!)
                        subject = nil
                    }))
                case .nameInvalid:
                    return nameInvalid
                }
            }
            .padding()
            .navigationTitle("Kurs bearbeiten")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .onAppear{
                subjectName = subject!.name
                lkSubject = subject!.lk ? 1 : 0
                selectedColor = color
            }
        }
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}
