//
//  ExamScreen.swift
//  Calq
//
//  Created by Kiara on 02.02.23.
//

import SwiftUI

struct ExamScreen: View {
    @StateObject var settings: AppSettings = getSettings()!
    @State var subjects: [UserSubject] = getAllSubjects()
    
    var body: some View {
        VStack{
            Text("ExamScreen")
            BlockView()
        }.padding()
    }
}
