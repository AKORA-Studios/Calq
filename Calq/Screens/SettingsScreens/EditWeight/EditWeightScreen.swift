//
//  ChangeWeightScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct ChangeWeightScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = WeightViewmodel()
    
    init() {
        if  #unavailable(iOS 16.0) {
            UITableView.appearance().backgroundColor = .clear
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("EditWeigthDesc")
                Image(systemName: "info.circle").onTapGesture {
                    vm.toggleHintText()
                }
            }
            
            Text("EditWeigthPrimaryHint")
                .foregroundColor(vm.showHintText ? .labelColor : .backgroundColor)
                .font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            
            VStack {
                Text("EditWeigthPickerTitle").frame(maxWidth: .infinity, alignment: .leading)
                Picker("EditWeigthPickerTitle", selection: $vm.selectedStepSize) {
                    Text("10").tag(stepSize.tenth)
                    Text("1").tag(stepSize.ones)
                    Text("0.1").tag(stepSize.fraction)
                }
                .pickerStyle(.segmented)
            }
            .padding()
            
            List {
                exampleWeightView()
                
                Section {
                    ForEach(vm.types.sorted(by: {$0.weigth > $1.weigth})) { type in
                        HStack {
                            HStack {
                                if Util.isPrimaryType(type) {
                                    Image(systemName: "star.fill")
                                } else {
                                    Image(systemName: "star")
                                }
                            }   .onTapGesture {}.onLongPressGesture(minimumDuration: 0.2) {
                                Util.setPrimaryType(type.id)
                                vm.load()
                            }
                            
                            if let typeWeight = vm.typeArr[type] {
                                Text("\(typeWeight.shorted)")
                                    .foregroundStyle(weightColor(typeWeight))
                                    .frame(width: 30).font(.footnote)
                                
                                TextField("", text: vm.binding(for: type.id))
                                    .foregroundStyle(weightColor(typeWeight))
                            }
                            
                            Spacer()
                            
                            Stepper("") {
                                vm.increment(type)
                            } onDecrement: {
                                vm.decrement(type)
                            }
                            
                            deleteView(type)
                            
                            if vm.showHintText {
                                Text("\(type.id)").foregroundColor(Color.gray).frame(width: 10).font(.footnote)
                            }
                        }
                    }
                }.listRowBackground(Color.gray.opacity(0.1))
                Section {
                    Text("EditWeigthNew")
                        .foregroundColor(Color.green)
                        .onTapGesture { vm.addWeigth()}
                }.listRowBackground(Color.gray.opacity(0.1))
            }.modifier(ListBackgroundModifier())
                .padding(0)
            
            Spacer()
            Text("EditWeigthSum".localized + "\(vm.summedUp.rounded(toPlaces: 2)) %")
                .foregroundColor(vm.summedUp > 100 ? Color.red : Color.gray)
            
            Button("saveDataWeight") {
                saveChanges()
            }.buttonStyle(PrimaryStyle())
                .disabled(vm.summedUp != 100.0)
                .padding()
            
        }.navigationTitle("EditWeigthTitle")
            .toolbar {Image(systemName: "xmark").onTapGesture {dismissSheet()}}
            .alert(isPresented: $vm.isAlertPresented) {
                switch vm.alertActiontype {
                case .deleteGrades:
                    let grade: [UserTest] = Util.getTypeGrades(vm.selectedDelete)
                    let str = grade.map {$0.name}.joined(separator: ", ")
                    return Alert(title: Text("EditWeigthWarningTitle"), message: Text("EditWeigthWarning \(str)"))
                case .wrongPercentage:
                    return  Alert(title: Text("EditWeigthAlertTitle"), message: Text("EditWeigthAlertText"))
                }
            }
    }
    
    func exampleWeightView() -> some View {
        Section {
            HStack {
                Image(systemName: "star")
            
                Text("%")
                    .foregroundStyle(.gray)
                    .frame(width: 30).font(.footnote)
                
                Text("Name")
                    .foregroundStyle(.gray)
                
                Spacer()
                
                Stepper("") {
                } onDecrement: {
                }.disabled(true)
                
                if vm.showHintText {
                    Text("ID").foregroundColor(Color.gray).frame(width: 10).font(.footnote)
                }
            }
        }
    }
    
    @ViewBuilder
    func deleteView(_ type: GradeType) -> some View {
        if vm.types.count > 2 && vm.getGradesForType(type).isEmpty {
            Image(systemName: "trash").foregroundColor(Color.red)
                .onTapGesture {vm.selectedDelete = type.id; vm.removeWeigth()}
        }
    }
    
    func weightColor(_ weight: Double) -> Color {
        return weight > 0.0 ? Color(uiColor: UIColor.label) : Color.red
    }
    
    func saveChanges() {
        if vm.summedUp > 100 {
            vm.isAlertPresented = true
            vm.alertActiontype = .wrongPercentage
            return
        }
        vm.saveWeigths()
        dismissSheet()
    }
    
    func dismissSheet() {
        self.presentationMode.wrappedValue.dismiss()
    }
}
