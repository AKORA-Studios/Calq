//
//  EditSubjectScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI


struct EditSubjectScreen: View {
    @Environment(\.managedObjectContext) var coreDataContext
    @Binding var editSubjectPresented: Bool
    
    @Binding var subject: UserSubject?
    @State var subjectName = ""
    @State var lkSubject = 0
    @State var selectedColor: Color = .accentColor
    
    @State var deleteAlert = false
    
    var body: some View{
        if(subject != nil) {
            let color = Color(hexString: subject!.color)
            VStack{
                ZStack{
                    VStack(alignment: .leading){
                        Text("Kursname")
                        TextField("Name", text: $subjectName).onChange(of: subjectName) { _ in
                            subject?.name = subjectName
                            saveCoreData()
                        }
                    }.padding()
                }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                
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
                }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                
                
                ZStack{
                    VStack(alignment: .leading){
                        Text("Kursfarbe")
                        
                        HStack{
                            ZStack{
                                RoundedRectangle(cornerRadius: 8).fill(selectedColor).frame(width: 30, height: 30)
                                Image(systemName: "paintpalette")
                            }
                            
                            ColorPicker("Farbe ändern", selection: $selectedColor, supportsOpacity: false).onChange(of: selectedColor) { newValue in
                                subject!.color = UIColor(selectedColor).toHexString()
                                saveCoreData()
                            }
                        }
                    }.padding()
                }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                
                Spacer().frame(height: 20)
                
                NavigationLink(destination: GradeListScreen(subject: subject!)) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                        Text("Noten bearbeiten").foregroundColor(.white)
                    }
                }
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8).fill(Color.red).frame(height: 40)
                    Text("Fach löschen").foregroundColor(.white)
                }.onTapGesture {
                    deleteAlert = true
                }
                
            }.alert(isPresented: $deleteAlert) {
                Alert(title: Text("Sure? >.>"), message: Text("Alle Kursdaten werrden gelöscht"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Löschen"),action: {
                    editSubjectPresented = false
                    Util.deleteSubject(subject!)
                    subject = nil
                }))
            }
            .padding()
                .navigationTitle("Kurs bearbeiten")
                .onAppear{
                    subjectName = subject!.name
                    lkSubject = subject!.lk ? 1 : 0
                    selectedColor = color
                }
        }
    }
}
