//
//  WhatsNewScreen.swift
//  Calq
//
//  Created by Kiara on 20.06.23.
//

import SwiftUI

struct WhatsNewScreen: View {
    @Binding var shouldDisplay: Bool
    @EnvironmentObject var vm: TabVM
    
    let newFuncs = [
        "📤 import/export von Prüfungen",
        "🗒️ custom Notentypen",
        "🇺🇸 neue Sprache verfügbar: Englisch",
        "📥 option demo daten zu laden beim ersten app launch",
        "ℹ️ anzeige der Notenanzahl und ob Prüfungsfach in 'Fach bearbeiten'",
        "🌸 fix einiger UI bugs",
        "🌸 UI des Prüfungsscreens angepasst",
        "🌸 dieser screen hier c:",
        "🌸 Der Slider bei 'neue Noten hinzufügen' starte bei dem Fachschnitt",
        "🌸 'Notenliste' zeigt nun nur noch zwei Jahreszahlen an um längere Notennamen darstellen zu können",
        "🌸 'Notenübersicht' zeigt nun die Summe der der Fächer an",
    ]
    
    let newFuncsGeneral = [
        "📤 import/export exams",
        "🗒️ custom gradetypes",
        "🇺🇸 new language available: english" ,
        "📥 option to load demo data at first launch",
        "ℹ️ show grade count and if subeject is exam in 'editSubject'",
        "🌸 fix some UI bugs",
        "🌸 reworked examscreen UI",
        "🌸 this screen c:",
        "🌸 in 'add new grade' the slider is now set to subject average on appear",
        "🌸 'gradelist' now shows only two year numbers to display longer test names",
        "🌸 'gradeoverview' now displays the sum of each subject",
    ]
    
    let lang = Locale.preferredLanguages[0]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                Text("Version \(appVersion)")
                    .font(.title)
                    .padding(.bottom, 20)
                
                ForEach(lang == "de-US" ? newFuncs : newFuncsGeneral, id:\.self) { feature in
                    Text(feature).padding(.bottom, 10)
                }
                
                Button("ToastOki") {
                    vm.checkForSheets()
                }.buttonStyle(PrimaryStyle())
                    .padding(.top, 10)
            }
        }.padding()
    }
}
