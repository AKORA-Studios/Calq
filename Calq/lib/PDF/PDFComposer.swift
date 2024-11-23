//
//  PDFComposer.swift
//  Calq
//
//  Created by Kiara on 23.11.24.
//

import Foundation

class PDFComposer {
    var date = ""
    var pdfFilename: String! = nil
    
    // Templates
    let pathToHTMLTemplate = Bundle.main.path(forResource: "template", ofType: "html")
    let pathToHTMLRowTemplate = Bundle.main.path(forResource: "template_row", ofType: "html")
    
    init() {
        
    }
    
    func renderPDF(date: String, items: [String], finalGrade: String) -> String {
        self.date = date
        
        do {
            var HTMLContent = try String(contentsOfFile: pathToHTMLTemplate!) //TODO: guard pls
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DATE#", with: date)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#FINAL_GRADE#", with: finalGrade)
            
            // table
            var allItems = ""
            for i in 0..<items.count {
                var itemHTMLContent = try String(contentsOfFile: pathToHTMLRowTemplate!) //TODO: guard pls
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TITLE#", with: items[i])
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#GRADE#", with: items[i])
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            return HTMLContent
            
        } catch {
            print("Couldnt create PDF")
        }
        return ""
    }
}
