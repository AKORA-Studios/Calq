//
//  AppStoreRating.swift
//  Calq
//
//  Created by Kiara on 24.06.23.
//

import StoreKit
    
func shouldAskForReview() -> Bool {
    if Util.getAllSubjects().count < 8 { return false }
    
    let nowTimestamp = Int(Date().timeIntervalSince1970)
    let lastTimestamp = Int(UserDefaults.standard.string(forKey: UD_lastAskedForeReview) ?? String(nowTimestamp)) ?? 0
    let timeIntervall = 60 * 60 * 24 * 7 * 4 * 3 // around 3 months
  
    if lastTimestamp + timeIntervall < nowTimestamp {
        UserDefaults.standard.set(nowTimestamp, forKey: UD_lastAskedForeReview)
        return true
    }
    
    return false
}

func askForReview() {
    guard let scene = UIApplication.shared.foregroundActiveScene else { return }
    SKStoreReviewController.requestReview(in: scene)
}

extension UIApplication {
    var foregroundActiveScene: UIWindowScene? {
        connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
    }
}
