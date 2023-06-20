//
//  NewGradeScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct NewGradeScreen: View {
    @State var subjects: [UserSubject] = Util.getAllSubjects()
    @StateObject var settings: AppSettings = Util.getSettings()
    @State var isSheetPresented = false
    @State var selectedSubject: UserSubject?
    
    var body: some View {
        NavigationView {
            List{
                if(subjects.isEmpty){
                    Text("ToastNoSubjects")
                }
                ForEach(subjects) { sub in
                    subjectView(sub)
                }
            }.navigationTitle("gradeNew")
        }.sheet(isPresented: $isSheetPresented, onDismiss: {selectedSubject = nil}) {
            NewGradeView(subject: $selectedSubject, dismiss: $isSheetPresented)
        }
        .onAppear{
            subjects = Util.getAllSubjects()
        }
    }
    
    @ViewBuilder
    func subjectView(_ sub: UserSubject) -> SettingsIcon {
        SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name, completation: {
            selectedSubject = sub
            isSheetPresented = true
        })
    }
}


struct NewGradeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var subject: UserSubject?
    @Binding var dismiss: Bool
    @State var gradeName = ""
    @State var gradeType = Util.getTypes()[0].id
    @State var year = 1
    @State var points: Float = 9
    @State var date = Date()
    @State var isAlertPresented = false
    
    var body: some View {
        NavigationView {
            if(subject != nil) {
                VStack{
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradeName")
                            TextField("gradeName", text: $gradeName)
                                .textFieldStyle(.roundedBorder)
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradeType")
                            Picker("gradeYear", selection: $gradeType) {
                                ForEach(Array(Util.getTypes().enumerated()), id: \.offset) { index, type in
                                    Text(type.name).tag(type.id)
                                }
                            }.pickerStyle(.segmented)
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradeHalfyear")
                            Picker("gradeYear", selection: $year) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").tag(3)
                                Text("4").tag(4)
                            }.pickerStyle(.segmented)
                            
                            HStack {
                                DatePicker("gradeDate", selection: $date, displayedComponents: [.date])
                            }
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("gradePoints")
                            HStack {
                                Text(String(Int(points)))
                                Slider(value: $points, in: 0...15, onEditingChanged: { _ in
                                    points = points.rounded()
                                })
                                .accentColor(Color.accentColor)
                            }
                            ImpactSegment(subject: $subject, gradeType: $gradeType, year: $year).frame(height: 35)
                        }.padding()
                    }.background(CardView())
                    
                    
                    Button("gradeNewAdd") {
                        saveGrade()
                    }.buttonStyle(PrimaryStyle())
                        .padding(.top, 20)
                    
                }.onAppear{
                    //set subjects latest year
                    year = Util.lastActiveYear(subject!)
                }
                .navigationTitle("gradeNew")
                    .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
                    .padding()
                    .alert(isPresented: $isAlertPresented){
                        Alert(title: Text("gradeInvalidName"), message: Text("gradeInvalidNameDesc"))
                    }
            }
        }
    }
    
    func saveGrade(){
        if(gradeName.isEmpty){
            isAlertPresented = true
            return
        }
        
        let newTest = UserTest(context: Util.getContext())
        newTest.name = gradeName
        newTest.grade =  Int16(points)
        newTest.date = date
        newTest.type = gradeType
        newTest.year = Int16(year)
        
        self.subject!.addToSubjecttests(newTest)
        saveCoreData()
        
        dismiss = false
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}
