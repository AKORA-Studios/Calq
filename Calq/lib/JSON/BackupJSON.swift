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
    static func saveBackup() {
        let data = JSON.exportJSON()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(fileprefix + "\(Date().millisecondsSince1970)" + ".json")
        
        do {
            let jsonData = try JSONEncoder().encode(data)
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
            return directoryContents.map { $0.lastPathComponent }.sorted()
            
        } catch {
            print("Failed to fetch backups form device: ", error)
            return []
        }
    }
    
    static func deleteBackup(_ url: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(url)
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        } catch {
            print("Could not delete file, probably read-only filesystem")
        }
    }
    
    static func importWithstringURL(_ url: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(url)
        do {
            try importJSONfromDevice(filePath)
        } catch {
            print("Failed to import backups form device: ", error)
        }
    }
    
    static func loadBackup(url: String) -> String {
        var str = ""
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(url)
        
        do {
            let json = (try String(contentsOf: filePath, encoding: String.Encoding.utf8).data(using: .utf8))
            if let json = json {
                str = String(data: json, encoding: .utf8) ?? "No Data could be parsed"
            }
        } catch {
            print("Failed laoding backup (\(url)) with: ", error)
        }
        
        return str.replacingOccurrences(of: "},", with: "},\n\n").replacingOccurrences(of: "}", with: "}\n")
    }
    
    static func parseFileName(_ url: String) -> String {
        let cleanedString = url.replacingOccurrences(of: fileprefix, with: "").replacingOccurrences(of: ".json", with: "")
        let timestamp = Int64(cleanedString) ?? 0
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: Date(milliseconds: timestamp))
    }
}
