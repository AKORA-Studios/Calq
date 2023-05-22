//
//  ChangeWeightScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import SwiftUI

struct ChangeWeightScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = WeigthViewmodel()
    
    var body: some View {
        VStack{
            Text("EditWeigthDesc")
            
            Text("EditWeigthPrimaryHint").font(.footnote)
                .multilineTextAlignment(.center)
                .padding(.top, 5)
            
            List {
                Section {
                    ForEach(Util.getTypes()) {type in
                        HStack {
                            if Util.isPrimaryType(type){
                                Image(systemName: "star.fill")
                            } else {
                                Image(systemName: "star")
                            }
                            Text("\(vm.typeArr[type]!)").frame(width: 20)
                                .font(.footnote)
                            
                            
                            TextField("", text: vm.binding(for: type.id))
                            Spacer()
                            
                            Stepper("") {
                                vm.increment(type)
                            } onDecrement: {
                                vm.decrement(type)
                            }
                            
                            Image(systemName: "trash").foregroundColor(Color.red)
                                .onTapGesture {vm.selectedDelete = type.id;removeWeigth()}
                            Text("\(type.id)").foregroundColor(Color.gray).frame(width: 10).font(.footnote)
                        }
                        .onTapGesture {}.onLongPressGesture(minimumDuration: 0.2) {
                            Util.setPrimaryType(type.id)
                            vm.load()
                        }
                        
                    }
                }.listRowBackground(Color.gray.opacity(0.1))
                Section {
                    Text("EditWeigthNew")
                        .foregroundColor(Color.green)
                        .onTapGesture { addWeigth()}
                }.listRowBackground(Color.gray.opacity(0.1))
            }.modifier(ListBackgroundModifier())
                .padding(0)
            
            Spacer()
            Text("EditWeigthSum\(vm.summedUp)")
                .foregroundColor(vm.summedUp > 100 ? Color.red : Color.gray)
            
            Button("saveData") {
                saveChanges()
            }.buttonStyle(PrimaryStyle())
            
        }.padding()
            .navigationTitle("EditWeigthTitle")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .alert(isPresented: $vm.isAlertPresented){
                switch vm.alertActiontype {
                case .deleteGrades:
                    let grade: [UserTest] = Util.getTypeGrades(vm.selectedDelete)
                    let str = grade.map{$0.name}.joined(separator: ", ")
                    return Alert(title: Text("EditWeigthWarningTitle"), message: Text("EditWeigthWarning \(str)"))
                case .wrongPercentage:
                    return  Alert(title: Text("EditWeigthAlertTitle"), message: Text("EditWeigthAlertText"))
                }
            }
    }
    
    init() {
        if #available(iOS 16.0, *) {
            // use ListBackgroundModifier
        } else {
            UITableView.appearance().backgroundColor = .clear
        }
        
    }
    
    func saveChanges(){
        if vm.summedUp > 100 {
            vm.isAlertPresented = true
            vm.alertActiontype = .wrongPercentage
            return
        }
        vm.saveWeigths()
        dismissSheet()
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
    
    func removeWeigth(){
        if vm.getGradesType().isEmpty {
            Util.deleteType(type: vm.selectedDelete)
            vm.load()
        } else {
            vm.isAlertPresented = true
            vm.alertActiontype = .deleteGrades
        }
    }
    
    func addWeigth(){
        Util.addType(name: "something", weigth: 0)
        vm.load()
    }
}
