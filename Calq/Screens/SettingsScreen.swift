//
//  SettingsScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI
import UIKit
struct SettingsScreen: View {
    @Environment(\.managedObjectContext) var coreDataContext
    @StateObject var settings: AppSettings = getSettings()!
    @State var subjects: [UserSubject] = getAllSubjects()
    
    var body: some View {
    
        List {
         
            SettingsIcon(color: Color.red, icon: "plus.app.fill", text: "Github")
            SettingsIcon(color: Color.red, icon: "plus.app.fill", text: "Load demo")
                .onTapGesture {JSON.loadDemoData() }
            
            ForEach(subjects) { sub in //sub.color,
                SettingsIcon(color: Color(hexString: sub.color), icon: "plus", text: sub.name)
            }
         /*   Section("Allgemein"){
             HStack {
                SettingsIcon(color: .teal, icon: "plus.app.fill")
                Text("Github")
            }
            }*/
            /*Section{
                HStack {
                    Text("Github")
                }
            }*/

           /* Section(header: Text("Kurse")){ //, footer: Text("Version ???")
                HStack {
              SettingsIcon(color: .teal, icon: "plus.app.fill")
              Text("Github")
          }
            }*/
        }
    }
}

struct SettingsIcon: View {
    var color: Color
    var icon: String
    var text: String

    var body: some View {
       HStack{
           ZStack{
               RoundedRectangle(cornerRadius: 8.0).fill(color).frame(width: 50, height: 50)
               Image(systemName: icon).foregroundColor(.blue)//.foregroundColor(.white)
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
