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
                    Text(formatJSON( vm.backup))
                }
                Button("backupSheet.load") {
                    JSON.importWithstringURL()
                    vm.reloadAndSave()
                    
                }.buttonStyle(PrimaryStyle())
                    .navigationTitle("backupNavTitle")
            }.padding(.horizontal)
    }
    
    func formatJSON(_ jsonString: String) -> String {
        guard let jsonData = jsonString.data(using: .utf8) else {
            return jsonString // return unformatted
        }
        
        var jsonObject: Any
        do {
             jsonObject =  try JSONSerialization.jsonObject(with: jsonData)
        } catch {
            return jsonString // return unformatted
        }

        var prettyJsonData: Data
        do {
            prettyJsonData = try JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted)
        } catch {
            return jsonString // return unformatted
        }
        
        let prettyPrintedJson = NSString(data: prettyJsonData, encoding: NSUTF8StringEncoding)!
        return prettyPrintedJson as String
    }
}
