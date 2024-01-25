//
//  BackupJSON.swift
//  Calq
//
//  Created by Kiara on 25.01.24.
//

import Foundation

extension JSON {
    private static var fileprefix = "calqBackup"
    /// save backup
    static func saveBackup(_ stuff: String) {
        print(stuff)
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(fileprefix + "\(Date().millisecondsSince1970)" + ".json")
        
        do {
            let jsonData = try JSONEncoder().encode(stuff)
            print(jsonData)
            try jsonData.write(to: filePath)
        } catch {
            print("Error writing to JSON backup file: \(error)")
        }
    }
    
    /// load backup names
    static func loadBackups() -> [String] {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: nil
            )
           // print("directoryContents:", directoryContents.map { $0.lastPathComponent })
            
            return directoryContents.map { $0.lastPathComponent }
           /* for url in directoryContents {
                x += 1
            }*/
            
        } catch(let error) {
            print("Failed to fetch bacups form device: ", error)
            return []
        }
    }
    
    static func parseFileName(_ url: String) -> String {
        let cleanedString = url.replacingOccurrences(of: fileprefix, with: "").replacingOccurrences(of: ".json", with: "")
        let timestamp = Int64(cleanedString) ?? 0
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: Date(milliseconds: timestamp))
    }
}
