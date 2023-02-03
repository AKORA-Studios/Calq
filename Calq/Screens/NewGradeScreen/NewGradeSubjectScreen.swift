//
//  NewGradeScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct NewGradeScreen: View {
    @State var subjects: [UserSubject] = getAllSubjects()
    @StateObject var settings: AppSettings = getSettings()!
    @State var isSheetPresented = false
    @State var selectedSubject: UserSubject?
    
    var body: some View {
        NavigationView {
            List{
                if(subjects.isEmpty){
                    Text("Oh no keine Fächer vorhanden :c") //TODO: other not data messages qwq
                }
                ForEach(subjects.indices) { i in
                    subjectView(subjects[i], i).onTapGesture {
                        selectedSubject = subjects[i]
                    }
                }
            }.navigationTitle("Neue Note")
        }.sheet(isPresented: $isSheetPresented, onDismiss: {selectedSubject = nil}) {
            NewGradeView(subject: selectedSubject!)
        }
    }
    
    @ViewBuilder
    func subjectView(_ sub: UserSubject, _ index: Int) -> SettingsIcon {
        SettingsIcon(color: settings.colorfulCharts ? getPastelColorByIndex(index) : Color(hexString: sub.color), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name)
    }
}


struct NewGradeView: View {
    @State var subject: UserSubject
    @State var gradeName = ""
    @State var bigGrade = false
    @State var year = 1
    @State var points: Float = 9
    @State var date = Date()
    
    var body: some View {
        NavigationView {
        VStack{
            VStack{
                Text("Notenname")
                TextField("Notenname", text: $gradeName)
            }.background(Color.gray.opacity(0.2))
            
            VStack{
                Text("Typ")
                TextField("Notenname", text: $gradeName)
            }.background(Color.gray.opacity(0.2))
            
            VStack{
                Text("Jahr")
                TextField("Notenname", text: $gradeName)
                HStack {
                    Text("Datum")
                    Text("Datum")
                }
            }.background(Color.gray.opacity(0.2))
            
            VStack{
                Text("Punkte")
                HStack {
                    Text(String(points))
                    Slider(value: $points, in: 0...15, onEditingChanged: { _ in
                        points = points.rounded()
                    })
                    .accentColor(getColor())
                }
            }.background(Color.gray.opacity(0.2))
            
            Button {
                saveGrade()
            } label: {
                Text("Note hinzufügen")
            }

            
        }.navigationTitle("Neue Note hinzufügen")
        }
    }
    
    
    func getColor() -> Color {
        return .green
    }
    
    
    func saveGrade(){
        
    }
}
