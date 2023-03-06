//
//  FirstLaunchScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct FirstLaunchScreen: View {
    @Binding var firstLaunch: Bool
    
    var body: some View {
        VStack{
            Spacer()
            Text("Welcome to Calq").font(.title)
            
            Text("Die Standardwertung von Klausur und Test beträgt 50% (Änderung des Verhältnis in den Einstellungen möglich)").multilineTextAlignment(.center)
            
            Spacer()
            
            
            Button("Oki") {
                UserDefaults.standard.set(true, forKey: "notFirstLaunch")
                firstLaunch = false
            }.buttonStyle(PrimaryStyle())
            
            Spacer()
            Text("Version: \(appVersion ?? "?.?.?")").font(.footnote)
        }.padding()
            .onAppear{
                Util.saveWeigth(50)
            }
    }
}
