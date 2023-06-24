//
//  TabView.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct TabbarView: View {
    @ObservedObject var vm = TabVM()
    
    var body: some View {
        ZStack {
            EmptyView()
                
            if vm.showOverlay {
                if vm.firstLaunch {
                    FirstLaunchScreen()
                        .environmentObject(vm)
                } else {
                    WhatsNewScreen()
                        .environmentObject(vm)
                }
            } else {
                tabview()
            }
        }.onAppear(perform: vm.checkForSheets)
        
    }
    
    @ViewBuilder
    func tabview() -> some View {
        TabView {
            OverviewScreen(vm: OverViewViewModel())
                .tabItem {Image(systemName: "chart.bar.fill")}
            
            SubjectListScreen()
                .tabItem {Image(systemName: "books.vertical.fill")}
            
            NewGradeScreen()
                .tabItem {Image(systemName: "plus.app.fill")}
            
            ExamScreen(vm: ExamViewModel())
                .tabItem { Image(systemName: "text.book.closed.fill")}
            
            SettingsScreen(vm: SettingsViewModel())
                .tabItem {Image(systemName: "gearshape.fill")}
        }
    }
}
