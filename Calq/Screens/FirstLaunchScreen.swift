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
            
            ZStack{
                RoundedRectangle(cornerRadius: 8).fill(Color.accentColor).frame(height: 40)
                Text("Oki")
            }.onTapGesture {
                print("hey")
                UserDefaults.standard.set(true, forKey: "notFirstLaunch")
                firstLaunch = false
            }
            
            Spacer()
            Text("Version: \(appVersion ?? "?.?.?")").font(.footnote)
        }.padding()
            .onAppear{
                Util.saveWeigth(50)
            }
    }
}
