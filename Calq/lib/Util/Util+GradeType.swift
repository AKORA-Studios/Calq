//
//  Util+GradeType.swift
//  Calq
//
//  Created by Kiara on 05.01.24.
//

import Foundation

extension Util {
    
    static func addType(name: String, weigth: Int) {
        let existingTypes = getTypes().map { $0.id }
        let newType = GradeType(context: getContext())
        newType.name = name
        newType.weigth = Int16(weigth)
        newType.id = getNewTypeID(existingTypes)
        
        let new = getTypes().map {Int($0.weigth)}.reduce(0, +)
        if new + weigth > 100 {
            newType.weigth = 0
        }
        let settings = Util.getSettings()
        settings.addToGradetypes(newType)
        saveCoreData()
    }
    
    private static func getNewTypeID(_ ids: [Int16]) -> Int16 { // yes UUIDs exist ik...
        for i in 0...(ids.max() ?? Int16(ids.count)) {
            if !ids.contains(Int16(i)) { return Int16(i) }
        }
        return Int16(ids.count + 1)
    }
    
    static func deleteType(type: Int16) {
        let type = getTypes().filter { $0.id == type }[0]
        getContext().delete(type)
        saveCoreData()
    }
    
    static func deleteType(type: GradeType) {
        getContext().delete(type)
        saveCoreData()
    }
    
    static func getTypes() -> [GradeType] {
        var types = getSettings().gradetypes!.allObjects as! [GradeType]
        if types.count >= 2 { return types}
        
        if types.count == 1 {
            addType(name: "default type", weigth: 0)
        } else if types.isEmpty {
            setTypes(Util.getSettings())
        }
        saveCoreData()
        types = getSettings().gradetypes!.allObjects as! [GradeType]
        return types.sorted(by: { $0.weigth > $1.weigth})
    }
    
    static func getTypeGrades(_ type: Int16) -> [UserTest] {
        var arr: [UserTest] = []
        for sub in Util.getAllSubjects() {
            for test in getAllSubjectTests(sub) {
                if test.type != type { continue }
                arr.append(test)
            }
        }
        return arr
    }
    
    static func isPrimaryType(_ type: GradeType) -> Bool {
        return isPrimaryType(type.id)
    }
    
    static func isPrimaryType(_ type: Int16) -> Bool {
        let types = getTypes().map { $0.id}
        if !types.contains(type) {setPrimaryType(types[0])}
        return type == UserDefaults.standard.integer(forKey: UD_primaryType)
    }
    
    static func setPrimaryType(_ type: Int16) {
        UserDefaults.standard.set(type, forKey: UD_primaryType)
    }
    
    /// add default grade types
    static func setTypes(_ settings: AppSettings, _ deleted: Bool = false) {
        let type1 = GradeType(context: getContext())
        type1.id = 0
        type1.name = "Test"
        type1.weigth = 50
        
        let type2 = GradeType(context: getContext())
        type2.id = 1
        type2.name = "Klausur"
        type2.weigth = 50
        
        settings.addToGradetypes(type1)
        settings.addToGradetypes(type2)
        
        setPrimaryType(type2.id)
        
        saveCoreData()
    }
}
