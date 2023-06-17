//
//  CalqApp.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

@main
struct Calq: App {
    var body: some Scene {
        WindowGroup {
                TabbarView()
                .environment(\.managedObjectContext, CoreDataStack.sharedContext)
                    .onAppear {
                        UserDefaults.standard.register(defaults: ["firstLaunch": true])
                    }
        }
    }
}
