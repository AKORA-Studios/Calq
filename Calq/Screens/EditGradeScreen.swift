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
                    Text("Notenname")
                    TextField("Notenname", text: $testName)
                }.padding()
            }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
            
            
            ZStack{
                VStack(alignment: .leading){
                    Text("Typ")
                    Picker("Typ", selection: $testType) {
                        Text("Test").tag(0)
                        Text("Klausur").tag(1)
                    }.pickerStyle(.segmented).colorMultiply(color)
                }.padding()
            }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
            
            
            ZStack{
                VStack(alignment: .leading){
                    Text("Halbjahr")
                    Picker("Jahr", selection: $testYear) {
                        Text("1").tag(1)
                        Text("2").tag(2)
                        Text("3").tag(3)
                        Text("4").tag(4)
                    }.pickerStyle(.segmented).colorMultiply(color)
                    
                    HStack {
                        DatePicker("Datum", selection: $testDate, displayedComponents: [.date])
                    }
                }.padding()
            }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
            
            
            ZStack{
                VStack(alignment: .leading){
                    Text("Punkte")
                    HStack {
                        Text(String(Int(testPoints)))
                        Slider(value: $testPoints, in: 0...15, onEditingChanged: { _ in
                            testPoints = testPoints.rounded()
                        })
                        .accentColor(Color.accentColor)
                    }
                }.padding()
            }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
            
            Spacer()
            
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                Text("Änderungen speichern")
            }.onTapGesture {saveGrade()}
            
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(Color.red).frame(height: 40)
                Text("Note löschen")
            }.onTapGesture {
                deleteAlert = true
            }
        }.padding()
            .navigationTitle("Note bearbeiten")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .onAppear{
                testName = test.name
                testYear = Int(test.year)
                testDate = test.date
                testPoints = Float(test.grade)
                testType = test.big ? 1 : 0
            }
            .alert(isPresented: $deleteAlert) {
                Alert(title: Text("Sicher?"), message: Text("Möchtest du diese Note wirklich löschen?"), primaryButton: .cancel(), secondaryButton: .destructive(Text("Oki"),action: {
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
