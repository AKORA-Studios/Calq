//
//  GradeListScreen.swift
//  Calq
//
//  Created by Kiara on 09.02.23.
//

import SwiftUI

struct GradeListScreen: View {
    var subject: UserSubject
    
    var body: some View {
            List{
                let Alltests = (self.subject.subjecttests!.allObjects as! [UserTest]).sorted(by: {$0.date < $1.date})
                if(!Alltests.isEmpty){
                    Section{
                        SettingsIcon(color: .red, icon: "archivebox", text: "Alle löschen").onTapGesture {
                            //TODO: delete all grades + alert
                        }
                    }
                }
                ForEach(1...4, id:\.self){i in
                    Section(header: Text("\(i). Halbjahr")){
                       
                        let tests =  Alltests.filter{$0.year == i};
                        ForEach(tests){test in
                            GradeIcon(test: test, color: getSubjectColor(subject))
                        }
                    }
                }.navigationTitle("Notenliste")
        }
    }
}


struct GradeIcon: View {
    var test: UserTest
    var color: Color
    
    var body: some View {
        let color = test.big ? color : Color.clear
        HStack{
            ZStack{
                RoundedRectangle(cornerRadius: 8.0).fill(color).frame(width: 30, height: 30)
                Text(String(test.grade))
            }
            Text(test.name).lineLimit(1)
            Spacer()
            Text(formatDate(date: test.date)).foregroundColor(.gray).fontWeight(.light)
        }
    }
    
    func formatDate(date: Date)-> String{
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd.MM.yyyy"
        return dateFormatter.string(from: date)
    }
}
