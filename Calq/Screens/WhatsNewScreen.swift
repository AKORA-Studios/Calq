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
        "⚙️ Grade weights can now also be 51.3!",
        "🌻 Quality of life improvement for iPads - Split view is now better supported",
        "➗ Subject Average is now also displayed in its Linechart"
    ]
    
    let newFuncsGeneral = [
        "⚙️ Notengewichte können nur auch 51.3 sein!",
        "🌻 Split View für iPad verbessert",
        "➗ Durchschnitt des Fachs wird im Verlaufsdiagram mit angezeigt"
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

struct WhatsNewScreen_Preview: PreviewProvider {
    static var previews: some View {
        WhatsNewScreen().environmentObject(TabVM())
    }
}
