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
                            ForEach(0..<Util.getSortingArray().count, id: \.self) { index in
                                Text(Util.getSortingArray()[index].name)
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
                vm.update()
            }
            .onAppear {
                vm.update()
            }
    }
    
    func halfyearSection(_ i: Int) -> some View {
        Section(header: Text("\(i + 1)gradeHalfyear")) {
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
                if Util.isPrimaryType(test.type) {
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill(color)
                        .frame(width: 30, height: 30)
                    Text(String(test.grade))
                } else {
                    RoundedRectangle(cornerRadius: 8.0)
                        .fill( Color.clear)
                        .frame(width: 30, height: 30)
                        .overlay(
                            RoundedRectangle(cornerRadius: 8)
                                .stroke(color, lineWidth: 1)
                        )
                    Text(String(test.grade))
                }
            }
            Text(test.name).lineLimit(1)
            Spacer()
            if !test.isFault {
                Text(vm.formatDate(date: test.date))
                    .foregroundColor(.gray)
                    .fontWeight(.light)
            }
        }
    }
}
