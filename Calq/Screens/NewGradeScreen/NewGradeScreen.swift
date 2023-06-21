//
//  NewGradeScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct NewGradeScreen: View {
    @ObservedObject var vm = NewGradeVM()
    
    var body: some View {
        NavigationView {
            List{
                if vm.subjects.isEmpty {
                    Text("ToastNoSubjects")
                }
                ForEach(vm.subjects) { sub in
                    subjectView(sub)
                }
            }.navigationTitle("gradeNew")
        }.sheet(isPresented: $vm.isNewGradeSheetPresented, onDismiss: {vm.selectedSubject = nil}) {
            NavigationView {
                NewGradeView()
                    .navigationTitle("gradeNew")
                    .environmentObject(vm)
            }
        }
        .onAppear{
            vm.updateViews()
        }
    }
    
    @ViewBuilder
    func subjectView(_ sub: UserSubject) -> SettingsIcon {
        SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name, completation: {
            vm.selectSub(sub)
        })
    }
}


struct NewGradeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: NewGradeVM
    
    var body: some View {
        ScrollView(showsIndicators: false){
            if vm.selectedSubject != nil {
                VStack{
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradeName")
                            TextField("gradeName", text: $vm.gradeName)
                                .textFieldStyle(.roundedBorder)
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradeType")
                            Picker("gradeYear", selection: $vm.gradeType) {
                                ForEach(Array(Util.getTypes().enumerated()), id: \.offset) { index, type in
                                    Text(type.name).tag(type.id)
                                }
                            }.pickerStyle(.segmented)
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradeHalfyear")
                            Picker("gradeYear", selection: $vm.year) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").tag(3)
                                Text("4").tag(4)
                            }.pickerStyle(.segmented)
                            
                            HStack {
                                DatePicker("gradeDate", selection: $vm.date, displayedComponents: [.date])
                            }
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradePoints")
                            HStack {
                                Text(String(Int(vm.points)))
                                Slider(value: $vm.points, in: 0...15, onEditingChanged: { _ in
                                    vm.points = vm.points.rounded()
                                })
                                .accentColor(Color.accentColor)
                            }
                            ImpactSegment(subject: $vm.selectedSubject, gradeType: $vm.gradeType, year: $vm.year).frame(height: 35)
                        }.padding()
                    }.background(CardView())
                    
                    
                    Button("gradeNewAdd") {
                        vm.saveGrade()
                    }.buttonStyle(PrimaryStyle())
                        .padding(.top, 20)
                }
                .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
                .padding()
                .alert(isPresented: $vm.isAlertPresented){
                    Alert(title: Text("gradeInvalidName"), message: Text("gradeInvalidNameDesc"))
                }
            }
        }
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}
