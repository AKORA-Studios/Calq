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
            
            if vm.showHintText {
                Text("EditWeigthPrimaryHint").font(.footnote)
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
            }
            
            List {
                Section {
                    ForEach(vm.types) { type in
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
                          
                            Text("\(vm.typeArr[type]!)").frame(width: 20).font(.footnote)
                            
                            TextField("", text: vm.binding(for: type.id))
                               
                            Spacer()
                     
                            Stepper("") {
                                vm.increment(type)
                            } onDecrement: {
                                vm.decrement(type)
                            }
                            
                            if vm.types.count > 2 && vm.getGradesForType(type)  {
                                Image(systemName: "trash").foregroundColor(Color.red)
                                    .onTapGesture {vm.selectedDelete = type.id; vm.removeWeigth()}
                            }
                           
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
            Text("EditWeigthSum\(vm.summedUp)")
                .foregroundColor(vm.summedUp > 100 ? Color.red : Color.gray)
            
            Button("saveDataWeight") {
                saveChanges()
            }.buttonStyle(PrimaryStyle())
            
        }.padding()
            .navigationTitle("EditWeigthTitle")
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
