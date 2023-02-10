//
//  EditSubjectScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI


struct EditSubjectScreen: View {
    @Binding var subject: UserSubject?
    @State var subjectName = ""
    @State var lkSubject = 0
    
    @State var showColorPicker = false
    
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
                                RoundedRectangle(cornerRadius: 8).fill(color).frame(width: 30, height: 30)
                                Image(systemName: "paintpalette")
                            }//.padding()
                            ZStack{
                                RoundedRectangle(cornerRadius: 8).fill(color).frame(height: 30)
                                Text("Farbe ändern")
                            }
                        }.onTapGesture {
                            showColorPicker = true //TODO: Color picker
                        }
                    }.padding()
                }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                
                Spacer().frame(height: 20)
                
                NavigationLink(destination: GradeListScreen(subject: subject!)) {
                    ZStack{
                        RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                        Text("Noten bearbeiten").foregroundColor(.white)
                    }
                }//.padding()
                
                ZStack{
                    RoundedRectangle(cornerRadius: 8).fill(Color.red).frame(height: 40)
                    Text("Fach löschen").foregroundColor(.white)
                }//.padding()
                
            }.padding()
                .navigationTitle("Kurs bearbeiten")
                .onAppear{
                    subjectName = subject!.name
                    lkSubject = subject!.lk ? 1 : 0
                }
        }
    }
}
