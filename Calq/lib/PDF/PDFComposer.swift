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
            
            // Header Localization
            HTMLContent = HTMLContent.replacingOccurrences(of: "#SUBJECT_HEADING#", with: "pdf.tableheader.subject".localized)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#TERMS_HEADING#", with: "pdf.tableheader.terms".localized)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#NUMBER_HEADING#", with: "pdf.tableheader.number".localized)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#POINTS_HEADING#", with: "pdf.tableheader.points".localized)
            HTMLContent = HTMLContent.replacingOccurrences(of: "#CREATED_AT_HEADING#", with: "pdf.tableheader.created".localized)
            
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
                // show table
                HTMLContent = HTMLContent.replacingOccurrences(of: "hiddenTable", with: "")
                // add exams
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
            
            // LOGO
           /* if let logo = UIImage(named: "AppIcon"), let data = logo.pngData() {
                let base64 = data.base64EncodedString(options: [])
                let imageForTheHtml = "data:image/gif;base64," + base64
                let html = "<img src='\(imageForTheHtml)'>"
                HTMLContent = HTMLContent.replacingOccurrences(of: "#LOGO#", with: html)
            }
            print(HTMLContent)*/
            
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
        for i in 0..<renderer.numberOfPages {
            UIGraphicsBeginPDFPage()
            renderer.drawPage(at: i, in: UIGraphicsGetPDFContextBounds())
        }
        UIGraphicsEndPDFContext()
        return data
    }
}
