//
//  SubjectDetailScreen.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

struct SubjectDetailScreen: View {
    @Binding var subject: UserSubject?
    @State var isGradeTablePresented = false
    
    var body: some View {
        NavigationView {
            if(subject !=  nil){
            VStack{
                Text("aloha")
            }.navigationTitle(subject!.name)
        }
        }
    }
}
