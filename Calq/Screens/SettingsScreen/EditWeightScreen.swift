//
//  ChangeWeightScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct ChangeWeightScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @State var stepperValue = 50
    
    var body: some View {
        VStack{
            Text("EditWeigthDesc")
            
                HStack{
                    VStack{
                        Text("subjectExam")
                        Text("subjectTest")
                    }.frame(width: 100)
                    
                    VStack {
                        Text(String(stepperValue) + " %")
                        Text(String(100 - stepperValue) + " %")
                    }.foregroundColor(.accentColor)
                    Stepper("") {
                        stepperValue += stepperValue == 100 ? 0 : 10
                    } onDecrement: {
                        stepperValue -= stepperValue == 0 ? 0 : 10
                    }
                }.padding()
                    .background(CardView())
                
            Spacer()
            
            Button("saveData") {
                saveChanges()
            }.buttonStyle(PrimaryStyle())
            
        }.padding()
            .navigationTitle("EditWeigthTitle")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .onAppear{
                stepperValue = Int(Double(Util.getSettings()!.weightBigGrades)! * 100)
            }
    }
    
    func saveChanges(){
        Util.saveWeigth(stepperValue)
        dismissSheet()
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}
