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
                
                VStack{
                    ForEach(1...5, id: \.self){ i in
                        ExamView(subject: getExam(i), type: i)
                            .environmentObject(vm)
                    }
                }.background(CardView())
                
                Spacer()
                
            }.onAppear{
                vm.updateViews()
                //resetExams() //if broken to debug ig
            }
            .padding()
            .navigationTitle("ExamViewTitle")
        }
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
        VStack{
            ZStack{
                Menu {
                    if(!vm.options.isEmpty){
                        Section {
                            ForEach(vm.options){sub in
                                Button(sub.name) {
                                    subject = sub
                                    saveExam(type, sub)
                                    vm.changeExamSelection()
                                    sliderValue = 0
                                }
                            }
                        }
                        Section {
                            Button {
                                removeExam(type, subject!)
                                vm.changeExamSelection()
                                subject = nil
                                sliderValue = 0
                            } label: {
                                Text("ExamViewSubRemove")
                            }.buttonStyle(MenuPickerDestructive())
                        }
                    }
                } label: {
                    Button {
                    } label: {
                        if subject != nil {
                            Text(subject!.name)
                        } else {
                            Text("ExamViewSubSelect")
                        }
                    }.buttonStyle(MenuPickerButton(color: getSubjectColor(subject), active: subject != nil))
                }
            }
            HStack {
                Text(String(Int(sliderValue.rounded())))
                Slider(value: $sliderValue, in: 0...15, onEditingChanged: { data in
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
        .onAppear{
            subject = getExam(type)
            sliderValue = (subject != nil) ? Float(Int(subject!.exampoints)) : 0
        }
    }
}
