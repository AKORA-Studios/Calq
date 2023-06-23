//
//  SubjectDetailScreen.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

struct SubjectDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var subject: UserSubject?
    @State var isGradeTablePresented = false
    
    @State var halfyearActive = false
    @State var selectedYear = 1
    @State var tests: [UserTest] = []
    
    @State var yearAverage = 0.0
    @State var yearAverageText = "-"
    
    var body: some View {
        if subject !=  nil {
            let color = getSubjectColor(subject!)
            ScrollView(showsIndicators: false) {
                VStack {
                    
                    Spacer()
                    
                    VStack(alignment: .leading, spacing: 5) {
                        Text("subjectDetailTime").padding(.top, 10)
                        LineChart(data: Binding.constant(lineChartData()), heigth: 90)
                    }
                    .padding(.horizontal)
                    .background(CardView())
                    .padding(.horizontal)
                    
                    VStack {
                        VStack(alignment: .leading) {
                            HStack {
                                Text("gradeHalfyear")
                                Spacer()
                                Text(halfyearActive ? "subjectDetailActive": "subjectDetailInactive").foregroundColor(halfyearActive ? color : .gray)
                            }
                            Picker("", selection: $selectedYear) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").tag(3)
                                Text("4").tag(4)
                            }.pickerStyle(.segmented)
                                .colorMultiply(color)
                                .onChange(of: selectedYear) { _ in
                                    update()
                                }
                        }.padding()
                        
                        ZStack {
                            let backroundColor = halfyearActive ? .red : color
                            RoundedRectangle(cornerRadius: 8).fill(backroundColor.opacity(0.5)).frame(height: 40)
                            Text(halfyearActive ? "subjectDetailDeactivate" : "subjectDetailActivate").foregroundColor(halfyearActive ? .red : .white)
                        }.padding()
                            .onTapGesture {
                                if halfyearActive { // deactivate
                                    Util.addYear(subject!, selectedYear)
                                } else { // activate
                                    Util.removeYear(subject!, selectedYear)
                                }
                                saveCoreData()
                                halfyearActive.toggle()
                            }
                    }.background(CardView())
                        .padding(.horizontal)
                    
                    // average chart
                    VStack(alignment: .leading, spacing: 5) {
                        Text("subjectDetailAverageHalfyear").padding()
                        CircleChart(perrcent: $yearAverage, color: color, upperText: $yearAverageText, lowerText: Binding.constant("")).frame(height: 120)
                    }.background(CardView())
                        .padding()
                    
                    NavigationLink(destination: GradeListScreen(subject: subject!)) {
                        Text("subjectDetailGradeList").foregroundColor(.white)
                    }.padding(.horizontal)
                        .buttonStyle(PrimaryStyle())
                }
                .navigationTitle(subject!.name)
                .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
            }.onAppear {
                selectedYear = Util.lastActiveYear(subject!)
                update()
            }
        }
    }
    
    func update() {
        withAnimation {
            let average = Util.getSubjectAverage(subject!, year: selectedYear, filterinactve: false)
            yearAverage = average / 15.0
            yearAverageText = String(format: "%.2f", average)
            halfyearActive = Util.checkinactiveYears(Util.getinactiveYears(subject!), selectedYear)
        }
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func lineChartData() -> [[LineChartEntry]] {
        if subject == nil { return [] }
        var arr: [[LineChartEntry]] = []
        var subArr: [LineChartEntry] = []
        
        let tests = Util.filterTests(subject!, checkinactive: false)
        let color = getSubjectColor(subject!)
        
        for test in tests {
            let time = (test.date.timeIntervalSince1970 / 1000)
            subArr.append(.init(value: Double(test.grade) / 15.0, date: time, color: color))
        }
        arr.append(subArr)
        return arr
    }
}
