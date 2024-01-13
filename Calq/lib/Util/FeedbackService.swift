//
//  FeedbackService.swift
//  Calq
//
//  Created by Kiara on 13.01.24.
//

import Foundation
import UIKit

class FeedbackService {
    static let version = "Version: \(appVersion) Build: \(buildVersion)"
    static let app = Bundle.main.infoDictionary?["CFBundleName"] ?? "Calq"
    static let device = UIDevice.current.name + " iOS: " + UIDevice.current.systemVersion
    
    static func sendFeedback(_ content: String) -> Bool {
        guard let url = URL(string: "https://discord.com/api/webhooks/1195726763649671168/XQATWsv9xGYVdamGsZDuc6kPX3hGyu5v5iC_wWssqErq2riswmA3vriFKMbiOcq6Pvxs") else { return false }
        let message = "**\(app)**\n*\(version)*\n*\(device)*\n-----------------------\n\(content)"
        let messageJSON: [String: Any] = ["content": message]
        let jsonData = try? JSONSerialization.data(withJSONObject: messageJSON)
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = jsonData
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
        return true
    }
}
