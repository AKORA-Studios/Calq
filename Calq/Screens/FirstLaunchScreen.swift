//
//  FirstLaunchScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct FirstLaunchScreen: View {
    @Binding var firstLaunch: Bool
    @State var loadDemoData = false
    
    var body: some View {
        VStack{
            Spacer()
            Text("Welcome to Calq").font(.title).padding(.bottom)
            
            Text("firstLaunchDesc").multilineTextAlignment(.center)
            
            Spacer()
            
            VStack {
                LineChart(data: Binding.constant([LineChartValue.example]))
                Button("firstLaunchLoadDemo") {
                    JSON.loadDemoData()
                    firstLaunch = false
                }.buttonStyle(SecondaryStyle())
                
            } .padding().background(CardView())
            
            Spacer()
            
            Button("firstLaunchGo") {
                UserDefaults.standard.set(true, forKey: "notFirstLaunch")
                firstLaunch = false
            }.buttonStyle(PrimaryStyle())
            
            Spacer()
            Text("Version: \(appVersion) Build: \(buildVersion)").font(.footnote)
        }.padding()
            .onAppear {
                setupAppearance()
            }
    }
    
    func setupAppearance() {
        UIPageControl.appearance().currentPageIndicatorTintColor = .black
        UIPageControl.appearance().pageIndicatorTintColor = UIColor.black.withAlphaComponent(0.2)
    }
}


struct FirstLaunchScreen_Preview: PreviewProvider {
    static var previews: some View {
        FirstLaunchScreen(firstLaunch: Binding.constant(true))
    }
}
