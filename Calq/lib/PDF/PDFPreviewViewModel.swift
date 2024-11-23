//
//  PDFPreviewViewModel.swift
//  Calq
//
//  Created by Kiara on 23.11.24.
//
import SwiftUI

class PDFPreviewViewModel: ObservableObject {
    var pdfComposer = PDFComposer()
    @Published var htmlContent: String = ""
    
    init() {
        self.htmlContent = generatePDF()
    }
    
    func generatePDF() -> String {
        var data: [PDFItem] = []
        let subjects = Util.getAllSubjects()
        let sumAverage =  PDFSum(subjectsgrade: String(Util.generalAverage() / 15), subjectpoints: String(format: "%.2f", Util.generalAverage()), finalgrade: String(Util.generalAverage()))
        
        for subject in subjects {
            let averageString = Util.getSubjectYearString(subject)
            
            data.append(PDFItem(title: subject.name, content: formatAverageString(averageString), grade: averageString[4]))
        }
        
        let result = pdfComposer.renderPDF(date: formatDate(), items: data, sum: sumAverage, exams: getFinals(subjects))
        htmlContent = result
        return result
    }
    
    func getFinals(_ subjects: [UserSubject]) -> [PDFExam] {
        var arr: [PDFExam] = []
        for index in 1...5 {
            if let exam = subjects.filter({$0.examtype == Int16(index)}).first {
                var item = PDFExam(title: exam.name, primary: (index == 1 || index == 2), points: String(exam.exampoints), num: index)
                arr.append(item)
            }
        }
        return arr
    }
    
    func formatAverageString(_ averageString: [String]) -> String {
        return averageString[0] + "\n" + averageString[1] + "\n" + averageString[2] + "\n" + averageString[3]
    }
    
    func formatDate() -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        
        return dateFormatter.string(from: Date())
    }
    
    func writePDF() -> URL {
        let data = pdfComposer.exportHTMLToPDF(htmlContent)
        
        let DocumentDirURL = try! FileManager.default
            .url(for: .applicationSupportDirectory, in: .userDomainMask, appropriateFor: nil, create: true).appendingPathComponent("exportData").appendingPathExtension("pdf")
        
        do {
            try data.write(to: DocumentDirURL)
        } catch let error as NSError {
            print("Failed writing to URL: \(DocumentDirURL), Error: " + error.localizedDescription)
        }
        return DocumentDirURL
        
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
        return subjectsgrade + " (" + subjectpoints + ")"
    }
}

struct PDFExam {
    var title: String
    var primary: Bool
    var points: String
    var num: Int
}
