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
    let pathToHTMLRowFinalsTemplate = Bundle.main.path(forResource: "template_row2", ofType: "html")
    
    func renderPDF(date: String, items: [PDFItem], sum: PDFSum, exams: [PDFExam]) -> String {
        self.date = date
        
        do {
            var HTMLContent = try String(contentsOfFile: pathToHTMLTemplate!)
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#DATE#", with: date)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#FINAL_GRADE#", with: sum.toString())
            HTMLContent = HTMLContent.replacingOccurrences(of: "#FINAL_GRADE2#", with: sum.finalgrade)
            
            // table
            var allItems = ""
            for i in 0..<items.count {
                var itemHTMLContent = try String(contentsOfFile: pathToHTMLRowTemplate!)
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TITLE#", with: items[i].title)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CONTENT1#", with: items[i].content[0])
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CONTENT2#", with: items[i].content[1])
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CONTENT3#", with: items[i].content[2])
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#CONTENT4#", with: items[i].content[3])
                
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#AVERAGE#", with: items[i].average)
                itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#GRADE#", with: items[i].grade)
                allItems += itemHTMLContent
            }
            
            // finals
            var finals = ""
            if !exams.isEmpty {
                for i in 0..<exams.count {
                    var itemHTMLContent = try String(contentsOfFile: pathToHTMLRowFinalsTemplate!)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TITLE#", with: exams[i].title)
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#TYPE#", with: String(exams[i].num))
                    itemHTMLContent = itemHTMLContent.replacingOccurrences(of: "#POINTS#", with: exams[i].points)
                    finals += itemHTMLContent
                }
            }
            
            HTMLContent = HTMLContent.replacingOccurrences(of: "#EXAMITEMS#", with: finals)
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
