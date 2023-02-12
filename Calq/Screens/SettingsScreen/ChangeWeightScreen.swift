//
//  ChangeWeightScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct ChangeWeightScreen: View {//TODO: change weigth screen
    @Environment(\.presentationMode) var presentationMode
    
    @State var stepperValue = 50
    
    var body: some View {
        VStack{
            Text("Wähle die Wertung der Noten in % aus")
            
            ZStack{
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
                RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)).frame(height: 70)
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
        
        
    }
    
   func saveChanges(){
       Util.saveWeigth(stepperValue)
       self.presentationMode.wrappedValue.dismiss()
    }
}
