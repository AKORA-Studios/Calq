//
//  SubjectDetailScreen.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

struct SubjectDetailScreen: View {
    @Binding var subject: UserSubject?
    @State var isGradeTablePresented = false
    
    @State var halfyearActive = false
    @State var slectedYear = 1
    
    var body: some View {
            if(subject !=  nil){
                let color = Color(hexString: subject!.color)
                VStack{
                    Text("insert inechart here xd") //TODO: linechart
                    
                    VStack{
                        //Year picker
                        ZStack{
                            VStack(alignment: .leading){
                                Text("Halbjahr")
                                Picker("", selection: $slectedYear) {
                                    Text("1").tag(1)
                                    Text("2").tag(2)
                                    Text("3").tag(3)
                                    Text("4").tag(4)
                                }.pickerStyle(.segmented)
                                    .colorMultiply(color)
                            }.padding()
                        }
                        
                        //Year toggle
                        HStack{
                            Toggle(isOn: $halfyearActive) {
                                Text("Halbjahr einbringen")
                            }
                        } .padding()
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                        .padding()
                    
                    //average chart
                    VStack(spacing: 5){
                        Text("Durchschnitt des Halbjahres")
                        CircleChart(perrcent: 0.5, color: color, upperText: String(format: "%.2f", 0.5)).frame(height: 150)
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))).padding()
                    
                    NavigationLink(destination: GradeListScreen(subject: subject!)) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                            Text("Notenliste ansehen").foregroundColor(.white)
                        }
                    }.padding()
                    
                .navigationTitle(subject!.name)
            }
        }
    }
}
