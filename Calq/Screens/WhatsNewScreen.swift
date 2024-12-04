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
        "📥 save Backup",
        "🗒️ Export to PDF (experimental)",
        "📄 PDF & JSON export preview",
        "💾 Removed common crash sources"
    ]
    
    let newFuncsGeneral = [
        "📥 Backups speichern",
        "🗒️ Export zu PDF (experimentell)",
        "📄 PDF & JSON Export Vorschau",
        "💾 Entfernen von häufige Absturzquellen"
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
