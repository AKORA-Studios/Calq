//
//  CalqApp.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

@main
struct Calq: App {
    @State var toastControl = ToastControl()
    
    var body: some Scene {
        WindowGroup {
            ZStack(alignment: .top) {
                TabbarView()
                ToastView()
            }
            .environment(\.managedObjectContext, CoreDataStack.sharedContext)
            .environmentObject(toastControl)
            .onAppear {
                UserDefaults.standard.register(defaults: [UD_firstLaunchKey: true])
                UserDefaults.standard.register(defaults: [UD_lastVersion: "0.0.0"])
                UserDefaults.standard.register(defaults: [UD_lastAskedForeReview: "\(Date().timeIntervalSince1970)"])
            }
        }
    }
}
