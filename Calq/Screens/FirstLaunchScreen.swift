//
//  FirstLaunchScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct FirstLaunchScreen: View {
    @EnvironmentObject var vm: TabVM
    
    var body: some View {
        VStack {
            Spacer()
            Text("Welcome to Calq").font(.title).padding(.bottom)
            
            Text("firstLaunchDesc").multilineTextAlignment(.center)
            
            Spacer()
            
            VStack {
             /*   TabView {
                    LineChart(data: Binding.constant(LineChartEntry.example))
                    BarChart(values: Binding.constant(BarChartEntry.exmaple))
                }  .tabViewStyle(.page)
                    .padding()*/
                BarChart(values: Binding.constant(BarChartEntry.exmaple))
               
                Button("firstLaunchLoadDemo") {
                    JSON.loadDemoData()
                    vm.showedFirstlaunch()
                }.buttonStyle(SecondaryStyle())
                    .accessibilityIdentifier(Ident.FirstLaunchScreen.loadDemoButton)
                
            }.padding().background(CardView())
            
            Spacer()
            
            Button("firstLaunchGo") {
                vm.showedFirstlaunch()
            }.buttonStyle(PrimaryStyle())
                .accessibilityIdentifier(Ident.FirstLaunchScreen.GoButton)
            
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
        FirstLaunchScreen()
    }
}
