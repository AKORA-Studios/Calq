//
//  CalqApp.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

@main
struct Calq: App {
    let persistenceController = CoreDataStack.shared
    
    var body: some Scene {
        WindowGroup {
            TabbarView()
                .environment(\.managedObjectContext, persistenceController.workingContext)
        }
    }
}



