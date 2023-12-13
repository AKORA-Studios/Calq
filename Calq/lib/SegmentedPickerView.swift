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
                .frame(height: 30)
                .shadow(radius: 2)
            
            HStack {
                ForEach(Array(entries.enumerated()), id: \.offset) { index, item in
                    let isSelected = vm.selectedIndex == index
                    Button {
                        vm.changedIndex(index)
                    } label: {
                        VStack(spacing: 2) {
                            Text(item)
                                .foregroundColor(isSelected ? vm.color : .gray)
                            if isSelected {
                                Rectangle()
                                    .fill(vm.color)
                                    .frame(height: 2)
                                    .padding(.horizontal, 4)
                                
                            }
                        }.frame(maxWidth: .infinity)
                    }.frame(maxWidth: .infinity)
                    
                    if index <= entries.count - 2 {
                        Divider()
                    }
                }
            }
            .frame(height: 20)
            .padding()
        }
    }
}

struct SegmentedPickerView_Preview: PreviewProvider {
    static var previews: some View {
        VStack {
            SegmentedPickerView(vm: SegmentedPickerViewModel())
        }.frame(width: 400)
  
    }
}

class SegmentedPickerViewModel: ObservableObject {
    @Published var color: Color = .red
    @Published var selectedIndex: Int = 0
    var delegate: SegmentedPickerViewDelegate?
    
    func changedIndex(_ index: Int) {
        if selectedIndex == index { return }
        withAnimation {
            selectedIndex = index
            delegate?.changedIndex(index)
        }
    }
    
    func setColor(_ color: Color) {
        DispatchQueue.main.async {
            self.color = color
        }
    }
}

protocol SegmentedPickerViewDelegate {
    func changedIndex(_ index: Int)
}
