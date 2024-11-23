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
            Text("PDFExport")
            HTMLStringView(htmlContent: generatePDF())
        }.padding(.vertical)
        .onAppear {
          //  generatePDF()
        }
    }
    
    func generatePDF() -> String {
        var data: [PDFItem] = []
        let sumAverage =  PDFSum(subjectsgrade: String(Util.generalAverage() / 15), subjectpoints: String(format: "%.2f", Util.generalAverage()), finalgrade: String(Util.generalAverage()))
        
        for subject in Util.getAllSubjects() {
            let averageString = Util.getSubjectYearString(subject)
            
            data.append(PDFItem(title: subject.name, content: formatAverageString(averageString), grade: averageString[4]))
        }
                    
        return pdfComposer.renderPDF(date: formatDate(), items: data, sum: sumAverage)
    }
    
    func formatAverageString(_ averageString: [String]) -> String {
        return averageString[0] + "|" + averageString[1] + "|" + averageString[2] + "|" + averageString[3]
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"

        return dateFormatter.string(from: Date())
    }
}

struct PDFItem {
    var title: String
    var content: String
    var grade: String
}

struct PDFSum {
    var subjectsgrade: String
    var subjectpoints: String
    var finalgrade: String
    
    func toString() -> String {
        return subjectsgrade + " (" + subjectpoints + ")" + " -> " + finalgrade
    }
}
