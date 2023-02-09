//
//  GradeListScreen.swift
//  Calq
//
//  Created by Kiara on 09.02.23.
//

import SwiftUI

struct GradeListScreen: View {
    @StateObject var settings: AppSettings = getSettings()!
    var subject: UserSubject
    
    var body: some View {
        NavigationView {
            List{
                ForEach(1...4, id:\.self){i in
                    Section(header: Text("\(i). Halbjahr")){
                        let Alltests = (self.subject.subjecttests!.allObjects as! [UserTest]).sorted(by: {$0.date < $1.date})
                        let tests =  Alltests.filter{$0.year == i};
                        ForEach(tests){test in
                            GradeIcon(test: test, color: color())
                        }
                    }
                }
            }.navigationTitle("Notenliste").padding(0) //TODO: padding? looks weird idk
        }
    }
    
    func color()->Color{
        let index = getAllSubjects().firstIndex(where: {$0.objectID == subject.objectID})!
        return settings.colorfulCharts ? getPastelColorByIndex(index) : Color(hexString: subject.color)
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
