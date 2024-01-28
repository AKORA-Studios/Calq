//
//  TabViewVM.swift
//  Calq
//
//  Created by Kiara on 24.06.23.
//

import SwiftUI
import WidgetKit

class TabVM: ObservableObject {
    @Published var showOverlay = false
    @Published var firstLaunch = false
    @Published var lastVersion = false
    @Published var repairData = false
    
    @Published var selectedIndex = 0
    
    func checkForSheets() {
        // check if app moves in background
        let notificationCenter = NotificationCenter.default
        notificationCenter.addObserver(self, selector: #selector(appMovedToBackground), name: UIApplication.willResignActiveNotification, object: nil)
        
        firstLaunch = !UserDefaults.standard.bool(forKey: UD_firstLaunchKey)
        lastVersion = Util.checkIfNewVersion()
        repairData = UserDefaults.standard.bool(forKey: UD_repairData)
        showOverlay = firstLaunch || lastVersion || repairData
 
        if lastVersion {
            UserDefaults.standard.set(appVersion, forKey: UD_lastVersion)
        }
    }
    
    func showedFirstlaunch() {
        showOverlay = false
        firstLaunch = false
        UserDefaults.standard.set(true, forKey: UD_firstLaunchKey)
    }
    
    func showedNewVersion() {
        showOverlay = false
        lastVersion = false
        UserDefaults.standard.set(appVersion, forKey: UD_lastVersion)
    }
    
    func showedRepairInfo() {
        repairData = false
        UserDefaults.standard.set(false, forKey: UD_repairData)
    }
    
    @objc func appMovedToBackground() {
        WidgetCenter.shared.reloadAllTimelines()
    }
}
