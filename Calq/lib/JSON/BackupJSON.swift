//
//  BackupJSON.swift
//  Calq
//
//  Created by Kiara on 25.01.24.
//

import Foundation

extension JSON {
    private static var fileprefix = "calqBackup"
    
    /// save backup every launch
    static func saveBackup() {
        let lastsave = UserDefaults.standard.string(forKey: UD_lastbackup)
        guard let lastsave = lastsave else { return }
        let date = Date(milliseconds: Int64(lastsave) ?? 0)
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy"
        
        if formatter.string(from: currentDate) == formatter.string(from: date) {
            print("Already saved backup today")
            return
        }
        
        UserDefaults.standard.set(String(currentDate.millisecondsSince1970), forKey: UD_lastbackup)
        
        let data = JSON.exportJSON()
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(fileprefix + "\(Date().millisecondsSince1970)" + ".json")
        
        do {
            try data.write(to: filePath, atomically: true, encoding: .utf8)
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
    
    /// delete backup file  from name  ex: 1324242424.json
    static func deleteBackup(_ url: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(url)
        
        do {
            try FileManager.default.removeItem(atPath: filePath.path)
        } catch {
            print("Could not delete file, probably read-only filesystem")
        }
    }
    /// import backup file
    static func importWithstringURL(_ url: String) {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        let filePath = documentsURL.appendingPathComponent(url)
        do {
            try importJSONfromDevice(filePath)
        } catch {
            print("Failed to import backups form device: ", error)
        }
        saveCoreData()
    }
    
    /// load backup file from name ex: 1324242424.json
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
    
    /// parse Date from file name  ex: 1324242424.json
    static func parseFileName(_ url: String) -> String {
        let cleanedString = url.replacingOccurrences(of: fileprefix, with: "").replacingOccurrences(of: ".json", with: "")
        let timestamp = Int64(cleanedString) ?? 0
        let formatter = DateFormatter()
        formatter.dateFormat = "dd.MM.yyyy HH:mm"
        return formatter.string(from: Date(milliseconds: timestamp))
    }
}
