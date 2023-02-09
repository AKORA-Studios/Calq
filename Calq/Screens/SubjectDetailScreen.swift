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
        NavigationView {
            if(subject !=  nil){
                VStack{
                    Text("insert inechart here xd") //TODO: linechart, notenliste<
                    
                    NavigationLink(destination: EmptyView()) {
                        Text("Notenliste")
                    }
                    
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
                            }.padding()
                        }
                        //Year toggle
                        HStack{
                            Toggle(isOn: $halfyearActive) {
                                Text("Halbjahr einbringen")
                            }
                            
                        } .padding()
                        
                        //average chart
                        
                        
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                        .padding()
                    
                    VStack(spacing: 5){
                        Text("Durchschnitt des Halbjahres")
                        CircleChart(perrcent: 0.5, upperText: String(format: "%.2f", 0.5)).frame(height: 150)
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))).padding()
                    
                    
                }.navigationTitle(subject!.name)
            }
        }
    }
}
