//
//  WhatsNewScreen.swift
//  Calq
//
//  Created by Kiara on 20.06.23.
//

import SwiftUI

struct WhatsNewScreen: View {
    @EnvironmentObject var vm: TabVM
    
    let newFuncs = [
        "🌸 Verbesserung der Diagramme durch Schatten",
        "📥 neues Widget für Halbjahre",
        "🇺🇸 Widget jetzt auch in Englisch",
        "🌸 Contextmenüs",
        "ℹ️ Möglichkeit 4 oder 5 Prüfungen zu haben",
    ]
    
    let newFuncsGeneral = [
        "🌸 Better diagramms with shadows",
        "📥 new Widget for halfyears",
        "🇺🇸 Widget texts are now also in english",
        "🌸 Contextmenus",
        "ℹ️ Option to choose 4 or 5 final exams",
    ]
    
    let lang = Locale.preferredLanguages[0]
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("Version \(appVersion)")
                    .font(.title)
                    .padding(.bottom, 20)
                
                ForEach(lang == "de-US" ? newFuncs : newFuncsGeneral, id: \.self) { feature in
                    Text(feature).padding(.bottom, 10)
                }
                
                Button("ToastOki") {
                    vm.showedNewVersion()
                }.buttonStyle(PrimaryStyle())
                    .padding(.top, 10)
            }
        }.padding()
    }
}
