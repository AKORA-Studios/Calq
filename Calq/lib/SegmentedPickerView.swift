//
//  SegmentedPickerview.swift
//  Calq
//
//  Created by Kiara on 07.12.23.
//

import SwiftUI

struct SegmentedPickerView: View {
    @State var index = 0
    @State var entries: [String] = ["1", "2", "3", "4"]
    @ObservedObject var vm: SegmentedPickerViewModel
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white)
                .frame(height: 45)
                .shadow(radius: 2).padding()
            
            HStack {
                ForEach(Array(entries.enumerated()), id: \.offset) { index, item in
                    let isSelected = vm.selectedIndex == index
                    Button {
                        vm.changedIndex(index)
                    } label: {
                        VStack (spacing: 5) {
                            Text(item)
                                .foregroundColor(isSelected ? vm.color : .gray)
                            if isSelected {
                                Rectangle()
                                    .fill(vm.color)
                                    .frame(height: 2)
                                    .padding(.horizontal)
                                
                            }
                        }
                    }.frame(maxWidth: .infinity)
                    
                    if index <= entries.count - 2 {
                        Divider()
                    }
                }
            }
            .frame(height: 30)
            .padding()
            
        }
    }
}

struct SegmentedPickerView_Preview: PreviewProvider {
    static var previews: some View {
        SegmentedPickerView(vm: SegmentedPickerViewModel())
    }
}

class SegmentedPickerViewModel: ObservableObject {
    @Published var color: Color = .red
    @Published var selectedIndex: Int = 0
    
    func changedIndex(_ index: Int) {
        if selectedIndex == index { return }
        withAnimation {
            selectedIndex = index
        }
    }
}
