//
//  WeightViewmodel.swift
//  Calq
//
//  Created by Kiara on 20.05.23.
//

import Combine
import SwiftUI

enum AlertType {
    case deleteGrades
    case wrongPercentage
}

class WeightViewmodel: ObservableObject {
    @Published var typeArr: [GradeType: Int16] = [:]
    @Published var summedUp: Int = 0
    
    @Published var selectedDelete: Int16 = 0
    @Published var isAlertPresented = false
    @Published var alertActiontype: AlertType = .wrongPercentage
    
    @Published var showHintText = false
    
    @Published var types = Util.getTypes()
    
    init() {
        load()
        reload()
    }
    
    func load() {
        types = Util.getTypes()
        for type in types {
            typeArr[type] = type.weigth
            typeArrNames[type.id] = type.name
        }
    }
    
    func getGradesType() -> [UserTest] {
        return Util.getTypeGrades(selectedDelete)
    }
    
    func getGradesForType(_ type: GradeType) -> [UserTest] {
        return Util.getTypeGrades(type.id)
    }
    
    func increment(_ type: GradeType) {
        typeArr[type]! += typeArr[type] == 100 ? 0 : 10
        reload()
    }
    
    func decrement(_ type: GradeType) {
        typeArr[type]! -= typeArr[type] == 100 ? 0 : 10
        if typeArr[type]! < 0 { typeArr[type]! = 0}
        reload()
    }
    
    func reload() {
        summedUp = Int(Array(typeArr.values).reduce(0, +))
    }
    
    func saveWeigths() {
        for type in types {
            type.weigth = typeArr[type]!
            type.name = typeArrNames[type.id]!
        }
        saveCoreData()
    }
    
    // MARK: Binding
    let didChange = PassthroughSubject<Void, Never>()
    
    var typeArrNames: [Int16: String] = [:] {
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
    
    func toggleHintText() {
        showHintText.toggle()
    }
    
    func addWeigth() {
        Util.addType(name: "something", weigth: 0)
        load()
    }
    
    func removeWeigth() {
        if getGradesType().isEmpty {
            Util.deleteType(type: selectedDelete)
            load()
        } else {
            isAlertPresented = true
            alertActiontype = .deleteGrades
        }
    }
}
