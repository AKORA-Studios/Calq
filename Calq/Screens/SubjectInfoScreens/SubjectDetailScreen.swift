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
    @State var selectedYear = 1
    @State var tests: [UserTest] = []
    
    @State var yearAverage = 0.0
    @State var yearAverageText = "-"
    
    var body: some View {
        if(subject !=  nil){
            let color = getSubjectColor(subject!)
            ScrollView(showsIndicators: false){
                VStack{
                    Spacer()
                    ZStack{
                        VStack(alignment: .leading, spacing: 5){
                            Text("Verlauf")
                            OneEntryLineChart(subject: subject!, heigth: 80).frame(height: 80)
                        }.padding()
                        RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))
                    }.padding(.horizontal)
                    
                    VStack{
                        //Year picker
                        ZStack{
                            VStack(alignment: .leading){
                                HStack{
                                    Text("Halbjahr")
                                    Spacer()
                                    Text(halfyearActive ? "Aktiv": "inaktiv").foregroundColor(halfyearActive ? color : .gray)
                                }
                                Picker("", selection: $selectedYear) {
                                    Text("1").tag(1)
                                    Text("2").tag(2)
                                    Text("3").tag(3)
                                    Text("4").tag(4)
                                }.pickerStyle(.segmented)
                                    .colorMultiply(color)
                                    .onChange(of: selectedYear) { newValue in
                                        update()
                                    }
                            }.padding()
                        }
                        ZStack{
                            let backroundColor = halfyearActive ? .red : color
                            RoundedRectangle(cornerRadius: 8).fill(backroundColor.opacity(0.5)).frame(height: 40)
                            Text("Halbjahr \(halfyearActive ? "deaktivieren" : "aktivieren")").foregroundColor(halfyearActive ? .red : .white)
                        }.padding()
                            .onTapGesture {
                                if(halfyearActive){ //deactivate
                                    _ = Util.addYear(subject!, selectedYear)
                                } else { //activate
                                    _ = Util.removeYear(subject!, selectedYear)
                                }
                                saveCoreData()
                                halfyearActive.toggle()
                            }
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                        .padding(.horizontal)
                    
                    //average chart
                    VStack(spacing: 5){
                        Text("Durchschnitt des Halbjahres").padding(.top)
                        CircleChart(perrcent: $yearAverage, color: color, upperText: $yearAverageText, lowerText: Binding.constant("")).frame(height: 150)
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2))).padding(.horizontal)
                    
                    NavigationLink(destination: GradeListScreen(subject: subject!)) {
                        ZStack{
                            RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                            Text("Notenliste ansehen").foregroundColor(.white)
                        }
                    }.padding(.horizontal)
                }
                .navigationTitle(subject!.name)
            }.onAppear{
                selectedYear = Util.lastActiveYear(subject!)
                update()
            }
        }
    }
    
    func update(){
        withAnimation {
            let average = Util.getSubjectAverage(subject!, year: selectedYear, filterinactve: false)
            yearAverage = average / 15.0
            yearAverageText = String(format: "%.2f", average)
            halfyearActive = Util.checkinactiveYears(Util.getinactiveYears(subject!), selectedYear)
        }
    }
}
