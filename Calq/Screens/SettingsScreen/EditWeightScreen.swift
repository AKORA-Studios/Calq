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
            Text("Wähle die Wertung der Noten in % aus")
            
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)).frame(height: 70)
                HStack{
                    VStack{
                        Text("Klausur")
                        Text("Test")
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
            }
            
            Spacer()
            
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                Text("Speichern").foregroundColor(.white)
            }.onTapGesture {
                saveChanges()
            }
        }.padding()
            .navigationTitle("Wertung ändern")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .onAppear{
                stepperValue = Int(Double(Util.getSettings()!.weightBigGrades)! * 10)
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
