//
//  SubjectDetailScreen.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

struct SubjectDetailScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: SubjectDetailViewModel
    
    @State var isGradeTablePresented = false
    
    var body: some View {
        let color = getSubjectColor(vm.subject)
        let _ = vm.pickerVM.setColor(color)
        
        ScrollView(showsIndicators: false) {
            VStack {
                
                Spacer()
                
                VStack(alignment: .leading, spacing: 5) {
                    Text("subjectDetailTime")
                        .padding(.top, 10)
                    LineChart(data: Binding.constant(vm.lineChartData()), heigth: 90)
                }
                .padding(.horizontal)
                .background(CardView())
                .padding(.horizontal)
                
                VStack {
                    VStack(alignment: .leading) {
                        HStack {
                            Text("gradeHalfyear")
                                .frame(minWidth: 50)
                            Spacer()
                            Text(vm.halfyearActive ? "subjectDetailActive": "subjectDetailInactive")
                                .foregroundColor(vm.halfyearActive ? color : .gray)
                        }
                        SegmentedPickerView(vm: vm.pickerVM)
                    }.padding()
                    
                    ZStack {
                        let backroundColor = vm.halfyearActive ? .red : color
                        RoundedRectangle(cornerRadius: 8)
                            .fill(backroundColor.opacity(0.5))
                            .frame(height: 40)
                        Text(vm.halfyearActive ? "subjectDetailDeactivate" : "subjectDetailActivate")
                            .foregroundColor(vm.halfyearActive ? .red : .white)
                    }.padding()
                        .onTapGesture {
                            vm.toggleHalfyear()
                        }
                }.background(CardView())
                    .padding(.horizontal)
                
                // average chart
                VStack(alignment: .leading, spacing: 5) {
                    Text("subjectDetailAverageHalfyear")
                        .padding()
                    CircleChart(percent: $vm.yearAverage, color: color, upperText: $vm.yearAverageText, lowerText: Binding.constant(""))
                        .frame(height: 120)
                }.background(CardView())
                    .padding()
                
                if vm.hasTest {
                    NavigationLink(destination: GradeListScreen(subject: vm.subject)) {
                        Text("subjectDetailGradeList")
                            .foregroundColor(.white)
                    }.padding(.horizontal)
                        .buttonStyle(PrimaryStyle())
                }
            }
            .navigationTitle(vm.subject.name)
            .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
        }.onAppear {
            vm.update()
        }
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
