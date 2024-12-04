//
//  BackupListView.swift
//  Calq
//
//  Created by Kiara on 20.11.24.
//

import SwiftUI

struct BackupListView: View {
    @ObservedObject var vm: SettingsViewModel
    
    var body: some View {
            VStack {
                ScrollView {
                    Text(JSON.formatJSON(vm.backup))
                }
                Button("backupSheet.load") {
                    JSON.importWithstringURL()
                    vm.reloadAndSave()
                    
                }.buttonStyle(PrimaryStyle())
                    .navigationTitle("backupNavTitle")
            }.padding(.horizontal)
    }
}
