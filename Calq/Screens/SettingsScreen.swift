//
//  SettingsScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct SettingsScreen: View {
    @Environment(\.managedObjectContext) var coreDataContext
    @StateObject var settings: AppSettings = getSettings()!
    @State var subjects: [UserSubject] = getAllSubjects()
    
    var body: some View {
        
        List{
            Section(header: Text("General")){
                SettingsIcon(color: Color.blue, icon: "info.circle.fill", text: "Github")
                
                SettingsIcon(color: Color.blue, icon: "chart.bar.fill", text: "automatische farben")
                
                SettingsIcon(color: Color.blue, icon: "folder.fill", text: "Noten importieren")
                
                SettingsIcon(color: Color.blue, icon: "square.and.arrow.up.fill", text: "noten exportieren")
                
                SettingsIcon(color: Color.yellow, icon: "square.stack.3d.down.right.fill", text: "wertung ändern")
                
                SettingsIcon(color: Color.orange, icon: "exclamationmark.triangle.fill", text: "Load demo data")
                    .onTapGesture {
                        JSON.loadDemoData()
                        subjects = getAllSubjects()
                    }
                
                SettingsIcon(color: Color.blue, icon: "trash.fill", text: "daten löschen")
            }
            Section(header: Text("Subjects")){
                ForEach(subjects.indices) { i in
                    subjectView(subjects[i], i)
                    SettingsIcon(color: .green, icon: "plus", text: "neues Fach")
                }
            }
        }.navigationTitle("Settings")
    }
    
    @ViewBuilder
    func subjectView(_ sub: UserSubject, _ index: Int) -> SettingsIcon {
        SettingsIcon(color: settings.colorfulCharts ? getPastelColorByIndex(index) : Color(hexString: sub.color), icon: sub.lk ? "bookmark.fill" : "bookmark", text: sub.name)
    }
}

struct SettingsIcon: View {
    var color: Color
    var icon: String
    var text: String
    
    var body: some View {
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8.0).fill(color).frame(width: 30, height: 30)
                Image(systemName: icon).foregroundColor(.white)
            }
            Text(text)
        }
    }
}


struct SettingsPreview: PreviewProvider {
    static var previews: some View {
        SettingsScreen()
    }
}

