import Foundation
import SwiftUI
import CoreData

struct AverageView: View {
    var body: some View {
        ProgressView("Loading...", value: Util.generalAverage(), total: 15)
            .progressViewStyle(CustomCircularProgressViewStyle())
    }
}

struct OverviewView: View {
    var subjects: [UserSubject] = Util.getAllSubjects()
    var settings = Util.getSettings()
    
    var body: some View {
        
        GeometryReader { geo in
            if self.subjects.isEmpty {
                VStack {
                    Spacer()
                    Text("Du hast noch keine Noten hinzugefügt qwq")
                    Spacer()
                }.padding(5)
                
            } else {
                HStack () {
                    ForEach(0..<subjects.count, id: \.self) { subject in
                        Spacer()
                        let height = geo.size.height - 30
                        
                        let subj = subjects[subject]
                        let grade =  (Util.getSubjectAverage(subj) * 100) / 15.0
                        
                        let name = (subj.name?.prefix(2) ?? "\(subject + 1)").uppercased()
                        let color = settings!.colorfulCharts ? Color(Util.getPastelColorByIndex(subject)) : Color(.accentColor)
                        
                        BarView(value: (grade * height) / 100, cornerRadius: CGFloat(4), text: String(format: "%.0f",round(Util.getSubjectAverage(subj))), height:height, color: color, subName: name)
                    }
                    Spacer()
                }
            }
        }
    }
}

struct BarView: View{
    var value: CGFloat
    var cornerRadius: CGFloat
    var text: String
    var height: CGFloat
    var color: Color
    var subName: String
    
    var body: some View {
        VStack {
            ZStack (alignment: .bottom) {
                ZStack (alignment: .bottom) {
                    
                    Text("--") .foregroundColor(.black)
                    RoundedRectangle(cornerRadius: cornerRadius).frame(width: 17, height: height).foregroundColor(Color(.systemGray4))
                    RoundedRectangle(cornerRadius: cornerRadius).frame(width: 17, height: value).foregroundColor(color)
                    Text(text)
                        .font(.footnote)
                        .fontWeight(.light)
                        .foregroundColor(.black)
                }
            }.padding(.top, 10)
            Text(subName).font(.system(size: 10)).fontWeight(.light).frame(width: 17, height: 3)
        }.padding(.bottom, 20)
    }
}

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    let color: Color = Color(.accentColor)
    let grade = String(format: "%.2f",Util.grade(number: Util.generalAverage()))
    
    func makeBody(configuration: Configuration) -> some View {
        VStack {
            HStack {
                Image(systemName: "chart.bar.fill")   .font(.system(size: 16.0)).foregroundColor(.accentColor)
                Text("Durchschnitt").foregroundColor(.accentColor)
            }.padding(.top, 10)
            
            ZStack {
                Circle()
                    .trim(from: 0.0, to: 1.0)
                    .stroke(Color(.systemGray4), style: StrokeStyle(lineWidth: 13.0, lineCap: .round))
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100)
                
                Circle()
                    .trim(from: 0.0, to: CGFloat(configuration.fractionCompleted ?? 0))
                    .stroke(color, style: StrokeStyle(lineWidth: 13.0, lineCap: .round))
                    .foregroundColor(.accentColor)
                    .rotationEffect(.degrees(-90))
                    .frame(width: 100)
                
                VStack {
                    Text(String(format: "%.01f", Util.generalAverage()))
                        .fontWeight(.bold)
                        .foregroundColor(color)
                        .frame(width: 90)
                    Text(grade)
                        .foregroundColor(color)
                        .frame(width: 90)
                }
            }
        }.padding(.bottom, 10)
    }
}
