//
//  EditGradeScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct EditGradeScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @State var test: UserTest
    var color: Color = .accentColor
    
    @State var testType = 0
    @State var testName = ""
    @State var testYear = 1
    @State var testDate = Date()
    @State var testPoints: Float = 9
    
    @State var deleteAlert = false
    
    var body: some View{
        VStack{
            VStack {
                VStack(alignment: .leading){
                    Text("gradeName")
                    TextField("gradeName", text: $testName)
                }.padding()
            }.background(CardView())
            
            
            ZStack{
                VStack(alignment: .leading){
                    Text("gradeType")
                    Picker("gradeType", selection: $testType) {
                        Text("gradeType1").tag(0)
                        Text("gradeType2").tag(1)
                    }.pickerStyle(.segmented).colorMultiply(color)
                }.padding()
            }.background(CardView())
            
            
            ZStack{
                VStack(alignment: .leading){
                    Text("gradeHalfyear")
                    Picker("gradeYear", selection: $testYear) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                    }.pickerStyle(.segmented).colorMultiply(color)
                    
                    HStack {
                        DatePicker("gradeDate", selection: $testDate, displayedComponents: [.date])
                    }
                }.padding()
            }.background(CardView())
            
            
            ZStack{
                VStack(alignment: .leading){
                    Text("gradePoints")
                    HStack {
                        Text(String(Int(testPoints)))
                        Slider(value: $testPoints, in: 0...15, onEditingChanged: { _ in
                            testPoints = testPoints.rounded()
                        })
                        .accentColor(Color.accentColor)
                    }
                }.padding()
            }.background(CardView())
            
            
            Button("gradeSave") {
                saveGrade()
            }.buttonStyle(PrimaryStyle())
                .padding(.top, 20)
            
            Button("gradeDelete") {
                deleteAlert = true
            }.buttonStyle(DestructiveStyle())
            
        }.padding()
            .navigationTitle("gradeEdit")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .onAppear{
                testName = test.name
                testYear = Int(test.year)
                testDate = test.date
                testPoints = Float(test.grade)
                testType = test.big ? 1 : 0
            }
            .alert(isPresented: $deleteAlert) {
                Alert(title: Text("ToastTitle"), message: Text("ToastDeleteGrade"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastOki"),action: {
                    deleteGrade()
                }))
            }
    }
    
    func deleteGrade(){
        dismissSheet()
        Util.deleteTest(test)
    }
    
    func saveGrade(){
        test.name = testName
        test.year = Int16(testYear)
        test.date = testDate
        test.grade = Int16(testPoints)
        test.big = testType == 1
        saveCoreData()
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}
