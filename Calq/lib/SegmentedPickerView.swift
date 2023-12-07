//
//  SegmentedPickerview.swift
//  Calq
//
//  Created by Kiara on 07.12.23.
//

import SwiftUI

struct SegmentedPickerView: View {
    @State var index = 0
    @State var entries: [String] = ["1", "2", "3"]
    @ObservedObject var vm: SegmentedPickerViewModel
    
    var body: some View {
        HStack {
            ForEach(Array(entries.enumerated()), id: \.offset) { index, item in
                
                Button {
                    vm.changedIndex(index)
                } label: {
                    VStack {
                        Text(item)
                            .foregroundColor(vm.color)
                        if vm.slectedIndex == index {
                            Rectangle()
                                .fill(vm.color)
                                .frame(height: 2)
                                .padding(.horizontal)
                            
                        }
                    }
                }.frame(maxWidth: .infinity)
                
                if index <= entries.count - 1 {
                    Divider()
                }
            }
        }.frame(height: 30)
    }
}

struct SegmentedPickerView_Preview: PreviewProvider {
    static var previews: some View {
        SegmentedPickerView(vm: SegmentedPickerViewModel())
    }
}

class SegmentedPickerViewModel: ObservableObject {
    @Published var color: Color = .red
    @Published var slectedIndex: Int = 0
    
    func changedIndex(_ index: Int) {
        withAnimation {
            slectedIndex = index
        }
    }
}
