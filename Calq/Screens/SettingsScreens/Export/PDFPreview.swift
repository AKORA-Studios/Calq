//
//  PDFPreview.swift
//  Calq
//
//  Created by Kiara on 01.12.24.
//

import SwiftUI
import WebKit

struct PDFPreview: View {
    var viewModel = PDFPreviewViewModel()
    
    var body: some View {
        VStack {
            Text("Loading . . .").opacity(viewModel.htmlContent.isEmpty ? 1 : 0)
            HTMLStringView(htmlContent: viewModel.generatePDF())
        }.navigationTitle("settingsExportPDF2")
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button {
                        let url = viewModel.writePDF()
                        showShareSheet(url: url)
                    } label: {
                        Label("Save", systemImage: "arrow.down.doc.fill")
                    }
                }
            }
    }
}

struct HTMLStringView: UIViewRepresentable {
    let htmlContent: String
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        uiView.loadHTMLString(htmlContent, baseURL: nil)
    }
}
