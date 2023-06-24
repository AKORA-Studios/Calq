//
//  SubjectListScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SubjectlistData: Hashable {
    var subject: UserSubject
    var yearString: [String]
    var colors: [Color]
}

struct SubjectListScreen: View {
    @ObservedObject var vm =  SubjectListVM()
    
    @State var gradeTablePresented = false
    @State var isSubjectDetailPResented = false
    
    var body: some View {
        NavigationView {
            List {
                Section {
                    ForEach(vm.data, id: \.self) {entry in
                        HStack {
                            let color = getSubjectColor(entry.subject)
                            let average = Util.testAverage(Util.filterTests(entry.subject))
                            
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
                        }
                        .onTapGesture {
                            vm.selectedSubejct = entry.subject
                            isSubjectDetailPResented = true
                        }
                    }
                }
                
                Section {
                    HStack {
                        ZStack {
                            RoundedRectangle(cornerRadius: 8)
                                .fill(Color.accentColor)
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
                        gradeTablePresented = true
                    }
                }
                .sheet(isPresented: $isSubjectDetailPResented) {
                    NavigationView {
                        SubjectDetailScreen(subject: $vm.selectedSubejct).onDisappear(perform: vm.updateViews)
                    }
                }
                .sheet(isPresented: $gradeTablePresented) {
                    NavigationView {
                        GradeTableOverviewScreen(subjects: vm.subjects)
                    }
                }
                .onAppear {
                    vm.updateViews()
                }
        }
    }
}
