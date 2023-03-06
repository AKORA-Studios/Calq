//
//  NewGradeScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct NewGradeScreen: View {
    @State var subjects: [UserSubject] = Util.getAllSubjects()
    @StateObject var settings: AppSettings = Util.getSettings()!
    @State var isSheetPresented = false
    @State var selectedSubject: UserSubject?
    
    var body: some View {
        NavigationView {
            List{
                if(subjects.isEmpty){
                    Text("Oh no keine Fächer vorhanden :c")
                }
                ForEach(subjects) { sub in
                    subjectView(sub)
                }
            }.navigationTitle("Neue Note")
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


//TODO: Dimiss button qwq
struct NewGradeView: View {
    @Environment(\.presentationMode) var presentationMode
    
    @Binding var subject: UserSubject?
    @Binding var dismiss: Bool
    @State var gradeName = ""
    @State var bigGrade = 1
    @State var year = 1
    @State var points: Float = 9
    @State var date = Date()
    @State var isAlertRPesented = false
    
    var body: some View {
        NavigationView {
            if(subject != nil) {
                VStack{
                    ZStack{
                        VStack(alignment: .leading){
                            Text("Notenname")
                            TextField("Notenname", text: $gradeName)
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("Typ")
                            Picker("Jahr", selection: $bigGrade) {
                                Text("Test").tag(1)
                                Text("Klausur").tag(2)
                            }.pickerStyle(.segmented)
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("Halbjahr")
                            Picker("Jahr", selection: $year) {
                                Text("1").tag(1)
                                Text("2").tag(2)
                                Text("3").tag(3)
                                Text("4").tag(4)
                            }.pickerStyle(.segmented)
                            
                            HStack {
                                DatePicker("Datum", selection: $date, displayedComponents: [.date])
                            }
                        }.padding()
                    }.background(CardView())
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("Punkte")
                            HStack {
                                Text(String(Int(points)))
                                Slider(value: $points, in: 0...15, onEditingChanged: { _ in
                                    points = points.rounded()
                                })
                                .accentColor(Color.accentColor)
                            }
                            ImpactSegment(subject: $subject, gradeType: $bigGrade, year: $year).frame(height: 35)
                        }.padding()
                    }.background(CardView())
                    
                    
                    Button("Note hinzufügen") {
                        saveGrade()
                    }.buttonStyle(PrimaryStyle())
                        .padding(.top, 20)
                    
                }.navigationTitle("Neue Note")
                    .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
                    .padding()
                    .alert(isPresented: $isAlertRPesented){
                        Alert(title: Text("Ungültiger Name"), message: Text("Der Name darf nicht leer sein"))
                    }
            }
        }
    }
    
    func saveGrade(){
        if(gradeName.isEmpty){
            isAlertRPesented = true
            return
        }
        
        let newTest = UserTest(context: CoreDataStack.shared.managedObjectContext)
        newTest.name = gradeName
        newTest.grade =  Int16(points)
        newTest.date = date
        newTest.big = bigGrade == 1 ? false : true
        newTest.year = Int16(year)
        self.subject!.addToSubjecttests(newTest)
        saveCoreData()
        
        dismiss = false
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}
