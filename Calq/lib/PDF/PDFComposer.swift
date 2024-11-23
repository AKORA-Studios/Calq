//
//  PDFComposer.swift
//  Calq
//
//  Created by Kiara on 23.11.24.
//

import UIKit

class PDFComposer {
    var date = ""
    var pdfFilename: String! = nil
    
    // Templates
    let pathToHTMLTemplate = Bundle.main.path(forResource: "template", ofType: "html")
    let pathToHTMLRowTemplate = Bundle.main.path(forResource: "template_row", ofType: "html")
    
    init() {
        
    }
    
    func renderPDF(date: String, items: [PDFItem], sum: PDFSum) -> String {
        self.date = date
        
        do {
            var HTMLContent = try String(contentsOfFile: pathToHTMLTemplate!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DATE#", with: date)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#FINAL_GRADE#", with: sum.toString())
            
            // table
            var allItems = ""
            for i in 0..<items.count {
                var itemHTMLContent = try String(contentsOfFile: pathToHTMLRowTemplate!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TITLE#", with: items[i].title)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CONTENT#", with: items[i].content)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#GRADE#", with: items[i].grade)
                allItems += itemHTMLContent
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#ITEMS#", with: allItems)
            return HTMLContent
            
        } catch {
            print("Couldnt create PDF")
        }
        return ""
    }
    
    func exportHTMLToPDF(_ content: String) -> Data {
        let renderer = PrintPageRenderer()
        let formatter = UIMarkupTextPrintFormatter(markupText: content)
        renderer.addPrintFormatter(formatter, startingAtPageAt: 0)
        return drawPDFUsingPrintPageRenderer(renderer) as Data
    }
    
    func drawPDFUsingPrintPageRenderer(_ renderer: UIPrintPageRenderer) -> NSData {
        let data = NSMutableData()
        UIGraphicsBeginPDFContextToData(data, CGRect.zero, nil)
        UIGraphicsBeginPDFPage()
        renderer.drawPage(at: 0, in: UIGraphicsGetPDFContextBounds())
        UIGraphicsEndPDFContext()
        return data
    }
}
