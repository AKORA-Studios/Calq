//
//  ExamScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct ExamScreen: View {
    @StateObject var settings: AppSettings = getSettings()!
    @State var examSubejcts: [UserSubject] = getAllExamSubjects()
    
    var body: some View {
        VStack{
            Text("ExamScreen")
            BlockView() //TODO: change points on exam select ect.
            
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.3))
                VStack{
                    ForEach(1...5, id: \.self){ i in
                        ExamView(subject: getExam(i), type: i).environmentObject(settings)
                    }
                }
            }
            
            Spacer()
        }.padding()
    }
}


struct ExamView: View {
    @Environment(\.managedObjectContext) var coreDataContext
    @State var subjects: [UserSubject] = getAllSubjects()
    @EnvironmentObject var settings: AppSettings
    @State var subject: UserSubject?
    
    @State var subjectName = "keines ausgewählt"
    @State var sliderText: String = "0"
    @State var sliderValue: Float = 0
    var type: Int
    
    
    var body: some View {
        VStack{
            ZStack{
                Menu {
                    Section {
                        ForEach(subjects){sub in
                            
                            Button(sub.name) {
                                subject = sub
                                saveExam(type, sub)
                            }
                        }
                    }
                    Section {
                        Button {
                            removeExam(type)
                            subject = nil
                        } label: {
                            Text("Entfernen/keines").foregroundColor(.red)
                        }
                    }
                   
                }label: {
                    RoundedRectangle(cornerRadius: 8).fill(subColor()).frame(height: 30)
                }

                Text((subject != nil) ? subject!.name : "keines ausgewählt")
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
        .padding(.vertical, 10)
        .onAppear{
            sliderValue = (subject != nil) ? Float(Int(subject!.exampoints)) : 0
        }/*.onDisappear{
            if(subject != nil){
                setExamPoints(Int(sliderValue), subject!)
            }
        }*/
    }
    
    func subColor() -> Color{
        if(subject == nil){return Color.gray}
        if(settings.colorfulCharts) {
            let index = subjects.firstIndex(where: {$0.objectID == subject!.objectID}) ?? 0
            return  getPastelColorByIndex(index)
        }
        return Color(hexString: subject!.color)
    }
}

