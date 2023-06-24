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

class TabVM: ObservableObject {
    @Published var showOverlay = false
    @Published var firstLaunch = false
    @Published var lastVersion = false
    
    func checkForSheets() {
        firstLaunch = !UserDefaults.standard.bool(forKey: UD_firstLaunchKey)
        lastVersion = Util.checkIfNewVersion()
        showOverlay = firstLaunch || lastVersion
        
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
}
