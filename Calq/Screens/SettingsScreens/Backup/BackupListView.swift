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
            List {
                ForEach(vm.backups, id: \.self) { url in
                    NavigationLink {
                        ScrollView {
                             Text(formatJSON(JSON.loadBackup(url: url)))
                        }.padding(.horizontal)
                            .navigationTitle(JSON.parseFileName(url))
                    } label: {
                        Text(JSON.parseFileName(url))
                    } .swipeActions {
                        Button("backupSheet.delete") {
                            JSON.deleteBackup(url)
                            vm.backups = JSON.loadBackups()
                        }
                        .tint(.red)
                        Button("backupSheet.load") {
                            JSON.importWithstringURL(url)
                            vm.reloadAndSave()
                        }
                    }
                }  .navigationTitle("backupNavTitle")
            }
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
