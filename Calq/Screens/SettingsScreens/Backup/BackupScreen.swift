//
//  BackupScreen.swift
//  Calq
//
//  Created by Kiara on 28.01.24.
//

import SwiftUI

struct BackupScreen: View {
    @EnvironmentObject var vm: TabVM
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(alignment: .leading) {
                Text("backupSheet.title")
                    .font(.title)
                    .padding(.bottom, 20)
           
                Text("backupSheet.text")
                
                Button("ToastOki") {
                    vm.showedRepairInfo()
                }.buttonStyle(PrimaryStyle())
                    .padding(.top, 10)
            }
        }.padding()
    }
}

struct BackupScreen_Preview: PreviewProvider {
    static var previews: some View {
        BackupScreen().environmentObject(TabVM())
    }
}
