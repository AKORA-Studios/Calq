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
    
    var body: some View {
        VStack {
        Text("ayo")
            
            Button("ToastOki") {
                vm.checkForSheets()
            }.buttonStyle(PrimaryStyle())
            
        }.padding()
    }
}
