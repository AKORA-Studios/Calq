//
//  SubjectListScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SubjectListScreen: View {
    @ObservedObject var vm =  SubjectListVM()

    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(vm.data, id: \.self) {entry in
                        HStack {
                            let color = getSubjectColor(entry.subject)
                            let average = Util.testAverage(Util.getAllSubjectTests(entry.subject, .onlyActiveHalfyears))
                            
                            ZStack {
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(color)
                                    .frame(width: 30, height: 30)
                                Text(String(format: "%.0f", round(average)))
                            }
                            Text(entry.subject.name)
                            
                            Spacer()
                            
                            HStack {
                                ForEach(0...3, id: \.self) { i in
                                    Text(entry.yearString[i])
                                        .foregroundColor(entry.colors[i])
                                        .frame(width: 25)
                                }
                            }
                        }.frame(maxWidth: .infinity)
                        .onTapGesture {
                            vm.selectSubject(entry.subject)
                        }
                    }
                }
                
                Section {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.calqColor)
                                .frame(width: 30, height: 30)
                            Text("∑")
                                .frame(width: 30, height: 30)
                                .frame(alignment: .center)
                        }
                        Text("\(vm.inactiveCount) subjectListYears \(vm.subjectCount)")
                    }
                }
            }.navigationTitle("subjectListTitle")
                .toolbar {
                    Button("subjectListTable") {
                        vm.gradeTablePresented = true
                    }
                }
                .sheet(isPresented: $vm.isSubjectDetailPResented) {
                    NavigationView {
                        if let selectedSubject = vm.selectedSubejct {
                            SubjectDetailScreen(vm: SubjectDetailViewModel(subject: selectedSubject)).onDisappear(perform: vm.updateViews)
                        }
                    }
                }
                .sheet(isPresented: $vm.gradeTablePresented) {
                    NavigationView {
                        GradeTableOverviewScreen(subjects: vm.subjects)
                    }
                }
                .onAppear {
                    vm.updateViews()
                }
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}
