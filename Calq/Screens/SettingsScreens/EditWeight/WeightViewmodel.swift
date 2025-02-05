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

enum stepSize {
    case tenth
    case ones
    case fraction
}

class WeightViewmodel: ObservableObject {
    @Published var typeArr: [GradeType: Double] = [:]
    @Published var summedUp: Double = 0.0
    
    @Published var selectedDelete: Int16 = 0
    @Published var isAlertPresented = false
    @Published var alertActiontype: AlertType = .wrongPercentage
    
    @Published var showHintText = false
    
    @Published var types = Util.getTypes()
    
    @Published var selectedStepSize = stepSize.tenth
    
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
        if typeArr[type] == nil { return }
        typeArr[type]! += typeArr[type]! >= 100.0 ? 0.0 : getStepValue()
        typeArr[type]! = typeArr[type]!.rounded(toPlaces: 2) //to prevent numbers like 26.200000000000003
        reload()
    }
    
    func decrement(_ type: GradeType) {
        if typeArr[type] == nil { return }
        typeArr[type]! -= typeArr[type]! <= 0-0 ? 0.0 : getStepValue()
        if typeArr[type]! < 0.0 { typeArr[type]! = 0.0}
        typeArr[type]! = typeArr[type]!.rounded(toPlaces: 2)
        reload()
    }
    
    func getStepValue() -> Double {
        switch selectedStepSize {
        case .tenth:
            return 10.0
        case .ones:
            return 1.0
        case .fraction:
            return 0.1
        }
    }
    
    func reload() {
        summedUp = Array(typeArr.values).reduce(0.0, +)
    }
    
    func saveWeigths() {
        for type in types {
            if let typeWeight = typeArr[type],
                let typeName = typeArrNames[type.id] {
                type.weigth = typeWeight
                type.name = typeName
            }
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
        let newName = "Type \(typeArr.count)"
        let newType = Util.addType(name: newName, weigth: 0)
        typeArr[newType] = newType.weigth
        typeArrNames[newType.id] = newType.name
        types.append(newType)
        objectWillChange.send()
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
