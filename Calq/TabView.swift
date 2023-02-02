//
//  TabView.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct TabbarView: View {
    
    var body: some View {
        TabView {
               OverviewScreen().tabItem{
                    Image(systemName: "chart.bar.fill")
               }

                SubjectListScreen().tabItem{
                   Image(systemName: "books.vertical.fill")
               }

               NewGradeScreen().tabItem{
                    Image(systemName: "plus.app.fill")
               }
               
               ExamScreen().tabItem{
                   Image(systemName: "text.book.closed.fill")
               }
               
               SettingsScreen()
                .navigationTitle("Settings")
                .tabItem{
                    Image(systemName: "gearshape.fill")
               }
           }
    }
}
