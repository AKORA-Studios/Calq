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
    @State var maxpoints1 = generatePossibleBlockOne()
    
    @State var points1 = generateBlockOne()
    @State var points2 = generateBlockTwo()
    
    var body: some View {
        VStack{
            Text("ExamScreen")
            BlockView()
        }.padding()
    }
    
    func h (){
        
    }
}


struct BlockView: View {
    @State var points1 = generateBlockOne()
    @State var points2 = generateBlockTwo()
    @State var maxpoints1 = generatePossibleBlockOne()
    
    var body: some View {
        GeometryReader { geo in
        ZStack{
            RoundedRectangle(cornerRadius: 8).fill(Color.gray.opacity(0.3))
            HStack(alignment: .center){
                VStack{
                    Text("Block 1").fontWeight(.bold)
                    RoundProgressBar(value: (points1 * 100 / maxpoints1), width: geo.size.width * 2/3)
                    Text("\(points1) von \(maxpoints1)").foregroundColor(.accentColor).fontWeight(.light)
                }.padding()
                
                VStack{
                    Text("Block 2").fontWeight(.bold)
                    RoundProgressBar(value: (points2 * 100 / 300), width: geo.size.width * 1/3)
                    Text("\(points2) von 300").foregroundColor(.accentColor).fontWeight(.light)
                }.padding()
            }
        }.frame(height: 60)
        }
    }
}



struct RoundProgressBar: View {
    @State var value: Int
    var width: CGFloat
    
    var body: some View {
        GeometryReader { geo in
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 8).frame(width: width * 2/3, height: 10)
                    .foregroundColor(.gray)
                
                RoundedRectangle(cornerRadius: 8).frame(width: (CGFloat(value)*width)/100 * 1/3, height: 10)
                    .foregroundColor(.accentColor)
            }
        }
    }
}
