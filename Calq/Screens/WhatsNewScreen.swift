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
        "ℹ️ anzeige von notenanzahl in 'Fach bearbeiten'",
        "🌸 fix einiger UI bugs"
    ]
    
    let newFuncsGeneral = [
        "📤 import/export exams",
        "🗒️ custom gradetypes",
        "🇺🇸 new language available: english" ,
        "📥 option to load demo data at first launch",
        "ℹ️ show garde count in editSubject",
        "🌸 fix some UI bugs"
    ]
    
    let lang = Locale.preferredLanguages[0]
    
    var body: some View {
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
            
        }.padding()
    }
}
