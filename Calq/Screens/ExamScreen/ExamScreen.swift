//
//  ExamScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct ExamScreen: View {
    @ObservedObject var vm: ExamViewModel
    @State var updateBlock2 = true
    
    var body: some View {
        NavigationView {
            ScrollView(showsIndicators: false) {
                BlockView()
                    .environmentObject(vm)
                    .padding(.bottom, 20)
                
                Text("ExamViewSubjects")
                    .font(.headline)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.top, 10)
                
                CardContainer {
                    let exams = vm.hasFiveExams ? 5 : 4
                    VStack {
                        ForEach(1...exams, id: \.self) { i in
                            ExamView(subject: getExam(i), type: i)
                                .environmentObject(vm)
                        }
                    }
                }
                
                Spacer()
                
            }.onAppear(perform: vm.updateViews)
                .padding()
                .navigationTitle("ExamViewTitle")
        }.navigationViewStyle(StackNavigationViewStyle())
    }
}

struct ExamView: View {
    @EnvironmentObject var vm: ExamViewModel
    @State var subject: UserSubject?
    
    @State var sliderText: String = "0"
    @State var sliderValue: Float = 0
    var type: Int
    
    init( subject: UserSubject? = nil, type: Int) {
        self.subject = subject
        self.type = type
        
        let thumbImage = UIImage(systemName: "circle.fill")
        UISlider.appearance().setThumbImage(thumbImage, for: .normal)
        // UISlider.appearance().thumbTintColor = .cyan//subject != nil ? UIColor(getSubjectColor(subject)) : UIColor.gray
    }
    
    var body: some View {
        VStack {
            Menu {
                Section {
                    ForEach(vm.options) {sub in
                        Button(sub.name) {
                            subject = sub
                            saveExam(type, sub)
                            vm.changeExamSelection()
                            sliderValue = 0
                        }
                    }
                }
                
                if subject != nil && !vm.options.isEmpty {
                    Section {
                        deleteExamButton()
                    }
                }
            } label: {
                Button {
                } label: {
                    if let subject = subject {
                        Text(subject.name)
                    } else {
                        Text("ExamViewSubSelect")
                    }
                }.buttonStyle(MenuPickerButton(color: getSubjectColor(subject), active: subject != nil))
            }
            
            HStack {
                Text(String(Int(sliderValue.rounded())))
                Slider(value: $sliderValue, in: 0...15, onEditingChanged: { _ in
                    sliderValue = sliderValue.rounded()
                    subject?.exampoints = Int16(sliderValue)
                    vm.updateBlocks()
                    saveCoreData()
                })
                .disabled(subject == nil)
            }
        }
        .padding(.horizontal, 10)
        .padding(.vertical, 5)
        .onAppear {
            sliderValue = 0
            if let subject = getExam(type) {
                sliderValue = Float(Int(subject.exampoints))
            }
        }
    }
    
    @ViewBuilder
    func deleteExamButton() -> some View {
        if #available(iOS 15.0, *) {
            Button(role: .destructive) {
                if let subject = subject {
                    removeExam(type, subject)
                }
                vm.changeExamSelection()
                subject = nil
                sliderValue = 0
            } label: {
                Label("ExamViewSubRemove", systemImage: "trash")
            }
        } else {
            Button {
                if let subject = subject {
                    removeExam(type, subject)
                }
                vm.changeExamSelection()
                subject = nil
                sliderValue = 0
            } label: {
                Text("ExamViewSubRemove")
            }.buttonStyle(MenuPickerDestructive())
        }
    }
}
