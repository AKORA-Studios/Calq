//
//  ExamScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct ExamScreen: View {
    @State var subjects: [UserSubject] = getAllSubjects()
    @State var options: [UserSubject] = []
    
    var body: some View {
        NavigationView {
            VStack(alignment: .leading){
                BlockView()//.frame(height: 70)
                Text("Prüfungsfächer").font(.headline)
                ZStack{
                    RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                    VStack{
                        ForEach(1...5, id: \.self){ i in
                            ExamView(subjects: $subjects, subject: getExam(i), type: i, options: $options)
                        }
                    }
                }
                Spacer()
            }.onAppear{
                //resetExams() //if broken to debug ig
                subjects = getAllSubjects()
                options = subjects.filter{$0.examtype == 0}
            }
            .onChange(of: subjects, perform: { _ in
                subjects = getAllSubjects()
                options = subjects.filter{$0.examtype == 0}
            })
            .padding()
            .navigationTitle("Prüfungsübersicht")
        }
    }
}


struct ExamView: View {
    @Binding var subjects: [UserSubject]
    @State var subject: UserSubject?
    
    @State var subjectName = "keines ausgewählt"
    @State var sliderText: String = "0"
    @State var sliderValue: Float = 0
    var type: Int
    @Binding var options: [UserSubject]
    
    
    var body: some View {
        VStack{
            ZStack{
                Menu {
                    if(!options.isEmpty){
                        Section {
                            ForEach(options){sub in
                                Button(sub.name) {
                                    subject = sub
                                    saveExam(type, sub)
                                    options = subjects.filter{$0.examtype == 0}
                                    sliderValue = 0
                                }
                            }
                        }
                        Section {
                            Button {
                                removeExam(type, subject!)
                                options = subjects.filter{$0.examtype == 0}
                                subject = nil
                                sliderValue = 0
                            } label: {
                                Text("Entfernen/keines")
                            }
                        }
                    }
                }label: {
                    RoundedRectangle(cornerRadius: 8).fill(subColor()).frame(height: 30)
                }
                
                Text((subject != nil) ? subject!.name : "Prüfung auswählen")
            }
            HStack {
                Text(String(sliderValue.rounded()))
                Slider(value: $sliderValue, in: 0...15, onEditingChanged: { data in
                    sliderValue = sliderValue.rounded()
                    subject?.exampoints = Int16(sliderValue)
                    saveCoreData()
                })
                .accentColor(subColor())
                .disabled(subject == nil)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .onAppear{
            subject = getExam(type)
            sliderValue = (subject != nil) ? Float(Int(subject!.exampoints)) : 0
        }
    }
    
    func subColor()-> Color{
        if(subject == nil){return Color.gray}
        return getSubjectColor(subject)
    }
}
