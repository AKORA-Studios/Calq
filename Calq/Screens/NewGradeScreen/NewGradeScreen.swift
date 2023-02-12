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
                    subjectView(sub).onTapGesture {
                        selectedSubject = sub
                        isSheetPresented = true
                    }
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
        SettingsIcon(color: getSubjectColor(sub), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name)
    }
}


//TODO: Dimiss button qwq
struct NewGradeView: View {
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
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                    
                    ZStack{
                        VStack(alignment: .leading){
                            Text("Typ")
                            Picker("Jahr", selection: $bigGrade) {
                                Text("Test").tag(1)
                                Text("Klausur").tag(2)
                            }.pickerStyle(.segmented)
                        }.padding()
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                    
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
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                    
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
                    }.background(RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.2)))
                    
                    Spacer()
                    
                    ZStack{
                        RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                        Text("Note hinzufügen")
                    }.onTapGesture {
                        saveGrade()
                    }
                }.navigationTitle("Neue Note").padding().alert(isPresented: $isAlertRPesented){
                    Alert(title: Text("Oh no"), message: Text("Diese Note gibt es bereis oder der Name ist ungültig"))
                }
            }
        }
    }
    
    func saveGrade(){
        if(Util.checkString(gradeName) || gradeName.isEmpty){
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
    
}
