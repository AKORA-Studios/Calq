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
            BlockView()
            
            ForEach(0...4, id: \.self){ i in
                //examSubejcts
                ExamView().environmentObject(settings)
            }
        }.padding()
    }
}



struct ExamView: View {
    @State var subjects: [UserSubject] = getAllSubjects()
    @EnvironmentObject var settings: AppSettings
    @State var subject: UserSubject?
    
    @State var subjectName = "keines ausgewählt" //TODO: pickers???
    @State var sliderText: String = "0"
    @State var sliderValue: Float = 0
    
    var body: some View {
        VStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(subColor()).frame(height: 30)
                Picker(selection: $subjectName) {
                    ForEach(subjects, id: \.self.objectID){sub in
                        Text(sub.name).tag(sub.objectID)
                    }
                    HStack{
                        Image(systemName: "exclamationmark.triangle.fill")
                        Text("keines")
                    }
                } label: {
                    Text("hi")
                }.onChange(of: subjectName) { newValue in
                    subject = subjects.first(where: {$0.name == subjectName})
                }

                Text((subject != nil) ? subject!.name : "")
            }
            HStack {
                Text(String(sliderValue))
                Slider(value: $sliderValue, in: 0...15).foregroundColor(subColor()).disabled(subject == nil)
            }
        }.onAppear{
            sliderValue = (subject != nil) ? Float(Int(subject!.exampoints)) : 0
        }
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


