//
//  PDFPreview.swift
//  Calq
//
//  Created by Kiara on 23.11.24.
//

import SwiftUI

struct PDFPreview: View {
    var pdfComposer = PDFComposer()
    
    var body: some View {
        VStack {
            Text("Ay")
            HTMLStringView(htmlContent: generatePDF())
        }.navigationTitle("Eeee")
        .onAppear {
          //  generatePDF()
        }
    }
    
    func generatePDF() -> String {
        return pdfComposer.renderPDF(date: "12.12.2012", items: ["eee", "ffff"], finalGrade: "? (? Points)")
    }
}
