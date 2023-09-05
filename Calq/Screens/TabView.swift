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
                    .environmentObject(vm)
            }
        }.onAppear(perform: vm.checkForSheets)
        
    }
    
    @ViewBuilder
    func tabview() -> some View {
        TabView(selection: $vm.selectedIndex) {
            OverviewScreen(vm: OverViewViewModel())
                .tabItem {Image(systemName: "chart.bar.fill")
                    accessibilityIdentifier(Ident.Main.tabBar_overview)
                }
                .tag(0)
            
            SubjectListScreen()
                .tabItem {Image(systemName: "books.vertical.fill")
                    accessibilityIdentifier(Ident.Main.tabBar_subjects)
                }
                .tag(1)
            
            NewGradeScreen()
                .tabItem {Image(systemName: "plus.app.fill")
                    .accessibilityIdentifier(Ident.Main.tabBar_addgrade)}
                .tag(2)
                
            
            ExamScreen(vm: ExamViewModel())
                .tabItem { Image(systemName: "text.book.closed.fill")
                    accessibilityIdentifier(Ident.Main.tabBar_exams)
                }
                .tag(3)
            
            SettingsScreen(vm: SettingsViewModel())
                .tabItem {Image(systemName: "gearshape.fill")
                    accessibilityIdentifier(Ident.Main.tabBar_settings)
                }
                .tag(4)
        }
    }
}
