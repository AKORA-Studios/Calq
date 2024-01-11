//
//  DocumentPicker.swift
//  Calq
//
//  Created by Kiara on 09.02.23.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    @Binding var fileURL: URL
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(fileURL: $fileURL)
    }
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.json], asCopy: true)
        controller.allowsMultipleSelection = false
        controller.shouldShowFileExtensions = true
        controller.delegate = context.coordinator
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
    }
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate {
    @Binding var fileURL: URL
    
    init(fileURL: Binding<URL>) {
        _fileURL = fileURL
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        fileURL = urls[0]
        
        Util.deleteSettings()
        
        do { try JSON.importJSONfromDevice(urls[0])} catch (let err){
            print("failed to import json from Device: ", err)
        }
        saveCoreData()
    }
}

// Export View
extension View {
    func showShareSheet(url: URL) {
        guard let source = UIApplication.shared.windows.last?.rootViewController else {
            return
        }
        
        let activityVC = UIActivityViewController(
            activityItems: [url],
            applicationActivities: nil)
        
        if let popoverController = activityVC.popoverPresentationController {
            popoverController.sourceView = source.view
            popoverController.sourceRect = CGRect(x: source.view.bounds.midX, y: source.view.bounds.midY, width: .zero, height: .zero)
            popoverController.permittedArrowDirections = []
        }
        source.present(activityVC, animated: true)
    }
}
