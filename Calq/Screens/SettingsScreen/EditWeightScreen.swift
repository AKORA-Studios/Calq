//
//  ChangeWeightScreen.swift
//  Calq
//
//  Created by Kiara on 10.02.23.
//

import Combine
import SwiftUI

struct ChangeWeightScreen: View {
    @Environment(\.presentationMode) var presentationMode
    @ObservedObject var vm = WeigthViewmodel()
    
    var body: some View {
        VStack{
            Text("EditWeigthDesc")
            
            List { // TODO: list background
                Section {
                    ForEach(Util.getTypes()) {type in
                        HStack {
                            Text("\(vm.typeArr[type]!)").frame(width: 30)
                            
                            
                            TextField("", text: vm.binding(for: type.id))
                            Spacer()
                            
                            Stepper("") {
                                vm.increment(type)
                            } onDecrement: {
                                vm.decrement(type)
                            }
                            
                            Image(systemName: "trash").foregroundColor(Color.red)
                                .onTapGesture {vm.selectedDelete = type.id;removeWeigth()}
                            Text("\(type.id)").foregroundColor(Color.gray).frame(width: 30)
                        }
                    }
                }
                Section {
                    Text("EditWeigthNew")
                        .foregroundColor(Color.green)
                        .onTapGesture { addWeigth()}
                }
            }
            
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


enum alertType{
    case deleteGrades
    case wrongPercentage
}

class WeigthViewmodel: ObservableObject {
    @Published var typeArr: [GradeType: Int16] = [:]
    @Published var summedUp: Int = 0
    
    @Published var selectedDelete: Int16 = 0
    @Published var isAlertPresented = false
    @Published var alertActiontype: alertType = .wrongPercentage
    
    init() {
        load()
        reload()
    }
    
    func load(){
        for type in Util.getTypes() {
            typeArr[type] = type.weigth
            typeArrNames[type.id] = type.name
        }
    }
    
    func getGradesType() -> [UserTest] {
        return Util.getTypeGrades(selectedDelete)
    }
    
    func increment(_ type: GradeType){
        typeArr[type]! += typeArr[type] == 100 ? 0 : 10
        reload()
    }
    
    func decrement(_ type: GradeType){
        typeArr[type]! -= typeArr[type] == 100 ? 0 : 10
        reload()
    }
    
    func reload(){
        summedUp = Int(Array(typeArr.values).reduce(0, +))
    }
    
    func saveWeigths(){
        for type in Util.getTypes() {
            type.weigth = typeArr[type]!
            type.name = typeArrNames[type.id]!
        }
        saveCoreData()
    }
    
    // MARK: Binding
    let didChange = PassthroughSubject<Void, Never>()
    
    var typeArrNames: Dictionary<Int16, String> = [:] {
        didSet {
            didChange.send(())
        }
    }
    
    func binding(for key: Int16) -> Binding<String> {
        return Binding(get: {
            return self.typeArrNames[key] ?? "AAAAA"
        }, set: {
            self.typeArrNames[key] = $0
        })
    }
}
