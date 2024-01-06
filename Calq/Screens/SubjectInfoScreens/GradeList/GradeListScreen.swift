//
//  GradeListScreen.swift
//  Calq
//
//  Created by Kiara on 09.02.23.
//

import SwiftUI

struct GradeListScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm: GradeListViewModel
    
    var body: some View {
        List {
            Section {
                SettingsIcon(color: .red, icon: "archivebox", text: "gradeTableDelete", completation: {
                    vm.deleteAlert = true
                })
            }
            ForEach(0...3, id: \.self) {i in
                let tests = vm.years[i]
                if !tests.isEmpty {
                    halfyearSection(i)
                }
            }
            
            if !vm.years[4].isEmpty { // if sorting is active
                ForEach(vm.years[4]) { test in
                    let color = getSubjectColor(vm.subject)
                    
                    NavigationLink {
                        EditGradeScreen(test: test, color: color)
                    } label: {
                        gradeIcon(test: test, color: color)
                    }
                }
            }
            
        }.navigationTitle("subjectGradeList")
            .toolbar {
                ToolbarItem {
                    Menu {
                        Picker(selection: $vm.sortCriteriaIndex) {
                            ForEach(0..<TestSortCriteria.array.count, id: \.self) { index in
                                Text(TestSortCriteria.array[index].name)
                            }
                        } label: {}
                    } label: {
                        Image(systemName: "slider.horizontal.3")
                    }
                }
                
                ToolbarItem { Image(systemName: "xmark").onTapGesture { dismissSheet() } }
            }
            .alert(isPresented: $vm.deleteAlert) {
                Alert(title: Text("ToastTitle"), message: Text("ToastDeleteGrades"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastDelete"), action: {
                    vm.deleteAction()
                    dismissSheet()
                }))
            }
            .onChange(of: vm.sortCriteriaIndex) { _ in
                vm.resortTests()
            }
    }
    
    func halfyearSection(_ i: Int) -> some View {
        Section(header: Text("\(i + 1). ") + Text("gradeHalfyear")) {
            ForEach(vm.years[i]) { test in
                let color = getSubjectColor(vm.subject)
                
                NavigationLink {
                    EditGradeScreen(test: test, color: color)
                } label: {
                    gradeIcon(test: test, color: color)
                }
            }
        }
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func gradeIcon(test: UserTest, color: Color) -> some View {
        HStack {
            ZStack {
                RoundedRectangle(cornerRadius: 8.0)
                    .fill(Util.isPrimaryType(test.type) ? color : Color.clear)
                    .frame(width: 30, height: 30)
                Text(String(test.grade))
            }
            Text(test.name).lineLimit(1)
            Spacer()
            Text(vm.formatDate(date: test.date))
                .foregroundColor(.gray)
                .fontWeight(.light)
        }
    }
}
