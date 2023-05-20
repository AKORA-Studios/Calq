//
//  TabView.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct TabbarView: View {
    @State var firstLaunch: Bool = true//!UserDefaults.standard.bool(forKey: "notFirstLaunch")
    
    var body: some View {
        TabView {
            OverviewScreen(vm: OverViewViewModel())
                .tabItem{Image(systemName: "chart.bar.fill")}
            
            SubjectListScreen()
                .tabItem{Image(systemName: "books.vertical.fill")}
            
            NewGradeScreen()
                .tabItem{Image(systemName: "plus.app.fill")}
            
            ExamScreen(vm: ExamViewModel())
                .tabItem{ Image(systemName: "text.book.closed.fill")}
            
            SettingsScreen(vm: SettingsViewModel())
                .tabItem{Image(systemName: "gearshape.fill")}
        }.sheet(isPresented: $firstLaunch) {
            FirstLaunchScreen(firstLaunch: $firstLaunch)
        }
    }
}
