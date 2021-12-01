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
        if self.subjects.count == 0 {
            VStack { Text("Keine Fächer qwq")}
            
          } else {
              GeometryReader { geo in
                 
                  HStack () {
                  ForEach(0..<subjects.count) { subject in
                      Spacer()
                   
                      let subj = subjects[subject]
                      let tests = Util.filterTests(subj);
                      let grade = tests.count != 0 ? 10 * round(Util.testAverage(tests)) : 0
                      
                      let height = geo.size.height - 20
                      let name = subj.name?.prefix(2) ?? "\(subject + 1)"
                      let color = settings!.colorfulCharts ? Color(Util.getPastelColorByIndex(subject)) : Color(.accentColor)
                      
                      BarView(value: (grade * 100)/height, cornerRadius: CGFloat(4), text: String(name), height:height, color: color)
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
    
    var body: some View {
     VStack {
         ZStack (alignment: .bottom) {
                RoundedRectangle(cornerRadius: cornerRadius).frame(width: 17, height: height).foregroundColor(Color(.systemGray4))
             RoundedRectangle(cornerRadius: cornerRadius).frame(width: 17, height: value).foregroundColor(color)
                Text(text)
                    .font(.footnote)
                    .fontWeight(.light)
                    .frame(height: 20)
                    .foregroundColor(.black)
                    
            }
     }.padding(.bottom, 10).padding(.top, 10)
    }
}

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    let color: Color = Color(.accentColor)
    let grade = String(format: "%.2f",Util.grade(number: Util.generalAverage()))
    
    func makeBody(configuration: Configuration) -> some View {
        
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
    }
}
