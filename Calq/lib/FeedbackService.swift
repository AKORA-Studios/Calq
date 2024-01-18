//
//  FeedbackService.swift
//  Calq
//
//  Created by Kiara on 14.01.24.
//

import Foundation
import UIKit

class FeedbackService {
    static let version = "Version: \(appVersion) Build: \(buildVersion)"
    static let app = Bundle.main.infoDictionary?["CFBundleName"] ?? "Calq"
    static let device = UIDevice.current.name + " iOS: " + UIDevice.current.systemVersion
    
    static func sendFeedback(_ content: String) -> Bool {
        guard let url = URL(string: "https://discord.com/api/webhooks/1195726763649671168/XQATWsv9xGYVdamGsZDuc6kPX3hGyu5v5iC_wWssqErq2riswmA3vriFKMbiOcq6Pvxs") else { return false }
        if !Reachability.isConnectedToNetwork() {
           return false
        }
        
        let message = "\(content)\n-----------------------\n**\(version)**\n*\(device)*"
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "content-type")
        request.httpBody = makeEmbed(message)
        
        let task = URLSession.shared.dataTask(with: request)
        task.resume()
        return true
    }
    
    private static func makeEmbed(_ content: String) -> Data {
        let feedback = Feedback(embeds: [Feedback.Embed(title: "\(app) Feedback", color: "7194610", description: content)])
        
        do {
            let data = try JSONEncoder().encode(feedback)
            return data
        } catch {
            return Data()
        }
    }
}

struct Feedback: Codable {
    var embeds: [Embed]
    
    struct Embed: Codable {
        var title: String
        var color: String
        var description: String
    }
}
