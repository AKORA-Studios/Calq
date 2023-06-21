//
//  BlockView.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

struct BlockView: View {
    @EnvironmentObject var vm: ExamViewModel
    
    var body: some View {
        VStack{
            bars()
        }
        .frame(height: 50)
        .onAppear{
            vm.updateBlocks()
        }
    }
    
    func bars() -> some View {
        GeometryReader { geo in
            HStack(alignment: .center){
                VStack(alignment: .leading){
                    Text("Block 1").fontWeight(.bold)
                    RoundProgressBar(value: $vm.points1, max: $vm.maxpoints)
                    Text("\(vm.points1) von \(vm.maxpoints)").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 2/3 - 20)
                Spacer()
                VStack(alignment: .leading){
                    Text("Block 2").fontWeight(.bold)
                    RoundProgressBar(value: $vm.points2, max: Binding.constant(300))
                    Text("\(vm.points2) von 300").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 1/3 - 20)
            }.padding(10)
                .background(CardView())
        }
    }
}


struct RoundProgressBar: View {
    @Binding var value: Int
    @Binding var max: Int
    
    var body: some View {
        GeometryReader { geo in
            let barProgressWidth =  (CGFloat(max != 0 ? (value * 100 / max) : 0) * geo.size.width)/100
            ZStack(alignment: .leading){
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(.gray)
                
                HStack(spacing: 0) {
                    if barProgressWidth + 10 < geo.size.width {
                        Spacer().frame(width: barProgressWidth - 5)
                        LinearGradient(colors: [.black.opacity(0.3), .clear], startPoint: .leading, endPoint: .trailing)
                            .clipShape(RoundedRectangle(cornerRadius: 8) )
                            .frame(width: 15, height: 8)
                    }
                }
                
                RoundedRectangle(cornerRadius: 8)
                    .frame(width: barProgressWidth, height: 8)
                    .foregroundColor(.accentColor)
            }.frame( height: 8)
        }
    }
}
