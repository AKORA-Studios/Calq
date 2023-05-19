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
    @State var isAlertPresented = false
    
    var body: some View {
        VStack{
            Text("EditWeigthDesc")
            
            List{
                ForEach(Util.getTypes()) {type in
                    HStack {
                        Text(type.name)
                        Spacer()
                        Text("\(vm.typeArr[type]!)")
                        Stepper("") {
                            vm.increment(type)
                        } onDecrement: {
                            vm.decrement(type)
                        }
                    }
                }
            }
            
            Spacer()
            Text("EditWeigthSum\(vm.summedUp)")
            
            Button("saveData") {
                saveChanges()
            }.buttonStyle(PrimaryStyle())
            
        }.padding()
            .navigationTitle("EditWeigthTitle")
            .toolbar{Image(systemName: "xmark").onTapGesture{dismissSheet()}}
            .alert(isPresented: $isAlertPresented){
                Alert(title: Text("EditWeigthAlertTitle"), message: Text("EditWeigthAlertText"))
            }
    }
    
    func saveChanges(){
        if vm.summedUp > 100 {
            isAlertPresented = true
            return
        }
        vm.saveWeigths()
        dismissSheet()
    }
    
    func dismissSheet(){
        self.presentationMode.wrappedValue.dismiss()
    }
}


class WeigthViewmodel: ObservableObject {
    @Published var typeArr: [GradeType: Int16] = [:]
    @Published var summedUp: Int = 0
    
    init() {
        for type in Util.getTypes() {
            typeArr[type] = type.weigth
        }
        reload()
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
        }
        saveCoreData()
    }
}
