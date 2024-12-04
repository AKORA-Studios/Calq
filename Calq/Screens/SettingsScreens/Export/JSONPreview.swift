//
//  JSONPreview.swift
//  Calq
//
//  Created by Kiara on 04.12.24.
//

import SwiftUI

struct JSONPreview: View {
    var json: String
    
    var body: some View {
        ScrollView {
            Text(JSON.formatJSON(json))
        }.navigationTitle("settingsExport2")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let url = JSON.writeJSON(json)
                        showShareSheet(url: url)
                    } label: {
                        Label("Save", systemImage: "arrow.down.doc.fill")
                    }
                }
            }
    }
}
