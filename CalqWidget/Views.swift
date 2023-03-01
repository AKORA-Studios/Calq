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
    @State var subjects: [UserSubject] = Util.getAllSubjects()
    var testData = [12,9,3,8]
    var settings = Util.getSettings()
    
    var body: some View {
        GeometryReader { geo in
            let fullHeigth = geo.size.height - 30
            VStack(alignment: .center) {
                
            if self.subjects.isEmpty {
             Spacer()
                HStack{
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                    Text("Du hast noch keine Noten hinzugefügt qwq").multilineTextAlignment(.center)
                    Image(systemName: "exclamationmark.triangle.fill").foregroundColor(.red)
                }.frame(width: geo.size.width - 20)
                Spacer()
               /* HStack{
                    ForEach(testData, id: \.self) { subj in
                        let grade =  Double(subj) / 15.0
                        let color = Color.red
                        
                        VStack(spacing: 0){
                            ZStack(alignment: .bottom){
                                Rectangle().frame( height: fullHeigth).foregroundColor(Color(.systemGray4)).topCorner()
                                Rectangle().frame( height: (fullHeigth * (grade))).foregroundColor(color).topCorner()
                                Text("11")
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .foregroundColor(.black)
                            }
                            Text("AA").font(.system(size: 9)).frame(height: 10)
                        }
                        
                    }
                }*/
            } else {
                HStack{
                    ForEach(subjects, id: \.self) { subj in
                        let average = Util.getSubjectAverage(subj)
                        let grade =  (average * 100) / 15.0
                        let color = getSubjectColor(subj)
                        
                        VStack(spacing: 0){
                            ZStack(alignment: .bottom){
                                Rectangle().frame( height: fullHeigth).foregroundColor(Color(.systemGray4)).topCorner()
                                Rectangle().frame( height: (fullHeigth * (grade / 100.0))).foregroundColor(color).topCorner()
                                Text(String(Int(average)))
                                    .font(.footnote)
                                    .fontWeight(.light)
                                    .foregroundColor(.black)
                            }
                            Text(subj.name.prefix(2).uppercased()).font(.system(size: 9)).frame(height: 10)
                        }
                    }
                }
            }
            }.padding(10)
        }
    }
}

struct CustomCircularProgressViewStyle: ProgressViewStyle {
    let color: Color = .accentColor
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
