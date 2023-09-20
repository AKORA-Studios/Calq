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
            List {
                if vm.subjects.isEmpty {
                    Text("ToastNoSubjects")
                }
                ForEach(vm.subjects) { sub in
                    subjectView(sub)
                }
            }.navigationTitle("gradeNew")
        }.navigationViewStyle(StackNavigationViewStyle())
        
        .sheet(isPresented: $vm.isNewGradeSheetPresented, onDismiss: {vm.selectedSubject = nil}) {
            NavigationView {
                NewGradeView()
                    .navigationTitle("gradeNew")
                    .environmentObject(vm)
            }
        }
        .onAppear {
            vm.updateViews()
        }
    }
    
    func subjectView(_ sub: UserSubject) -> SettingsIcon {
        SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name, completation: {
            vm.selectSub(sub)
        })
    }
}

struct NewGradeView: View {
    @Environment(\.presentationMode) var presentationMode
    @EnvironmentObject var vm: NewGradeVM
    @EnvironmentObject var toastControl: ToastControl
    
    init() {
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        // UISlider.appearance().thumbTintColor = .cyan//subject != nil ? UIColor(getSubjectColor(subject)) : UIColor.gray
    }
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            if vm.selectedSubject != nil {
                let color = getSubjectColor(vm.selectedSubject)
                
                VStack {
                    CardContainer {
                        VStack(alignment: .leading) {
                            Text("gradeName")
                            TextField("gradeName", text: $vm.gradeName)
                                .textFieldStyle(.roundedBorder)
                        }
                    }
                    
                    CardContainer {
                        VStack(alignment: .leading) {
                            Text("gradeType")
                            Picker("gradeYear", selection: $vm.gradeType) {
                                ForEach(Array(Util.getTypes().enumerated()), id: \.offset) { _, type in
                                    Text(type.name).tag(type.id)
                                }
                            }.pickerStyle(.segmented)
                                .colorMultiply(color)
                        }
                    }
                    
                    CardContainer {
                        VStack(alignment: .leading) {
                            Text("gradeHalfyear")
                            Picker("gradeYear", selection: $vm.year) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").tag(3)
                                Text("4").tag(4)
                            }.pickerStyle(.segmented)
                                .colorMultiply(color)
                            
                            HStack {
                                DatePicker("gradeDate", selection: $vm.date, displayedComponents: [.date])
                            }
                        }
                    }
                    
                    CardContainer {
                        VStack(alignment: .leading) {
                            Text("gradePoints")
                            HStack {
                                Text(String(Int(vm.points)))
                                Slider(value: $vm.points, in: 0...15, onEditingChanged: { _ in
                                    vm.points = vm.points.rounded()
                                })
                                .accentColor(Color.accentColor)
                            }
                            ImpactSegment(subject: $vm.selectedSubject, gradeType: $vm.gradeType, year: $vm.year).frame(height: 35)
                        }
                    }
                    
                    Button("gradeNewAdd") {
                        vm.saveGrade()
                        toastControl.show("gradeNewToastSuccess", .success)
                    }.buttonStyle(PrimaryStyle())
                        .padding(.top, 20)
                }
                .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
                .padding()
                .alert(isPresented: $vm.isAlertPresented) {
                    Alert(title: Text("gradeInvalidName"), message: Text("gradeInvalidNameDesc"))
                }
            }
        }
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
