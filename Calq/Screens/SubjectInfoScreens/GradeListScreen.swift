//
//  GradeListScreen.swift
//  Calq
//
//  Created by Kiara on 09.02.23.
//

import SwiftUI

struct GradeListScreen: View {
    @Environment(\.presentationMode) var presentationMode
    var subject: UserSubject
    @State var years: [[UserTest]] = [[],[],[],[]]
    @State var Alltests: [UserTest] = []
    @State var deleteAlert = false
    
    var body: some View {
        List{
            if(!Alltests.isEmpty){
                Section{
                    SettingsIcon(color: .red, icon: "archivebox", text: "gradeTableDelete", completation: {
                        deleteAlert = true
                    })
                }
                
                ForEach(0...3, id:\.self){i in
                    Section(header: Text("\(i + 1). ") + Text("gradeHalfyear")){
                        let tests =  years[i]
                        ForEach(tests){test in
                            let color = getSubjectColor(subject)
                            
                            NavigationLink {
                                EditGradeScreen(test: test, color: color)
                            } label: {
                                GradeIcon(test: test, color: color)
                            }
                        }
                    }
                }
            } else {
                Text("noGrades")
            }
            
        }.navigationTitle("subjectListTitle")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .onAppear{
                Alltests = (self.subject.subjecttests!.allObjects as! [UserTest]).sorted(by: {$0.date < $1.date})
                
                years[0] = Alltests.filter{$0.year == 1};
                years[1] = Alltests.filter{$0.year == 2};
                years[2] = Alltests.filter{$0.year == 3};
                years[3] = Alltests.filter{$0.year == 4};
            }
            .alert(isPresented: $deleteAlert) {
                Alert(title: Text("ToastTitle"), message: Text("ToastDeleteGrades"), primaryButton: .cancel(), secondaryButton: .destructive(Text("ToastDelete"),action: {
                    subject.subjecttests = []
                    saveCoreData()
                    dismissSheet()
                }))
            }
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}


struct GradeIcon: View {
    @State var test: UserTest
    @State var color: Color
    @State var name = ""
    @State var date = ""
    @State var points = "-"
    
    var body: some View {
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8.0).fill(color).frame(width: 30, height: 30)
                Text(points)
            }
            Text(name).lineLimit(1)
            Spacer()
            Text(date).foregroundColor(.gray).fontWeight(.light)
        }.onAppear{
       //     color =  test.big ? color : Color.clear
            color = Color.purple //TODO: h
            name = test.name
            date = formatDate(date: test.date)
            points = String(test.grade)
        }
    }
    
    func formatDate(date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
