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
        "ℹ️ Frage anch AppstoreRating",
        "🌸 ContextMenüs in Einstellungen",
        "🌸 dieser screen hier c:",
        "🌸 Toasts",
        "🌸 Schatten im Kresidiagramm",
        "🌸 Einfluss neur Noten mit 0 Notenpunkten"
    ]
    
    let newFuncsGeneral = [
        "",
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
                    .accessibilityIdentifier(Ident.WhatsNewScreen.okButton)
            }
        }.padding()
    }
}
