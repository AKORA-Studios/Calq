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
    let util = Util()
    
    var body: some Scene {
        WindowGroup {
            NavigationView{
            TabbarView()
                .environment(\.managedObjectContext, persistenceController.workingContext)
               // .environmentObject(util)
                
            }
        }
    }
}



