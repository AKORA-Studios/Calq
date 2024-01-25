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
            // here landmarkData.json file is empty
        } catch {
            print("Error writing to JSON file: \(error)")
        }
        
    }
    
    /// load backup names
    static func loadBackups() -> Int {
        let documentsURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!
        var x = 0
        
        do {
            let directoryContents = try FileManager.default.contentsOfDirectory(
                at: documentsURL,
                includingPropertiesForKeys: nil
            )
            print("directoryContents:", directoryContents.map { $0.lastPathComponent })
            for url in directoryContents {
                x += 1
            }
            
        } catch(let error) {
            print("ehhh laoding to working", error)
        }
        
        return x
    }
}
