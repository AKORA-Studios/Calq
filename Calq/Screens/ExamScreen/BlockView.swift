//
//  BlockView.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//

import SwiftUI

/// Creates the final grade block View, containing "Block 1" (subject term points) and "Block 2" (final exam points)
struct BlockView: View {
    @EnvironmentObject var vm: ExamViewModel

    var body: some View {
        VStack {
            bars()
        }
        .frame(height: 50)
        .onAppear {
            vm.updateBlocks()
        }
    }

    func bars() -> some View {
        GeometryReader { geo in
            HStack(alignment: .center) {
                VStack(alignment: .leading) {
                    Text("Block 1").fontWeight(.bold)
                    RoundProgressBar(value: $vm.points1, max: $vm.maxpoints)
                    Text("\(vm.points1) von \(vm.maxpoints)").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 2/3 - 20)
                Spacer()
                VStack(alignment: .leading) {
                    Text("Block 2").fontWeight(.bold)
                    RoundProgressBar(value: $vm.points2, max: Binding.constant(300))
                    Text("\(vm.points2) von 300").foregroundColor(.accentColor).fontWeight(.light)
                }.frame(width: geo.size.width * 1/3 - 20)
            }.padding(10)
                .background(CardView())
        }
    }
}

/// Creates the bar View for thr exma Blocks
/// - Parameters:
///     - value: the current value
///     - max: the maximum value
/// > Warning: Unexpeted behaviour if max < value
struct RoundProgressBar: View {
    @Binding var value: Int
    @Binding var max: Int

    var body: some View {
        GeometryReader { geo in
            let barProgressWidth =  (CGFloat(max != 0 ? (value * 100 / max) : 0) * geo.size.width)/100
            ZStack(alignment: .leading) {
                RoundedRectangle(cornerRadius: 8)
                    .foregroundColor(Color(.systemGray4))

                HStack(spacing: 0) {
                    if barProgressWidth + 10 < geo.size.width && barProgressWidth - 5 > 0 {
                        Spacer().frame(width: barProgressWidth - 5)
                        LinearGradient(colors: [.black.opacity(0.2), .clear], startPoint: .leading, endPoint: .trailing)
                            .clipShape(RoundedRectangle(cornerRadius: 8) )
                            .frame(width: 15, height: 8)
                    }
                }

                RoundedRectangle(cornerRadius: 8)
                    .frame(width: barProgressWidth, height: 8)
                    .foregroundColor(.accentColor)
            }.frame(height: 8)
        }
    }
}

struct RoundProgressBar_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            RoundProgressBar(value: Binding.constant(0), max: Binding.constant(100))
            RoundProgressBar(value: Binding.constant(20), max: Binding.constant(100))
            RoundProgressBar(value: Binding.constant(20), max: Binding.constant(20))
        }.padding()
    }
}
