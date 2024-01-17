//
//  AppSettings+CoreDataProperties.swift
//  Calq
//
//  Created by Kiara on 03.09.23.
//
//

import Foundation
import CoreData
import SwiftUI


extension AppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var colorfulCharts: Bool
    @NSManaged public var weightBigGrades: String?
    @NSManaged public var hasFiveExams: Bool
    @NSManaged public var showGradeTypes: Bool
    
    @NSManaged public var gradetypes: NSSet?
    @NSManaged public var usersubjects: NSSet?

}

// MARK: Generated accessors for gradetypes
extension AppSettings {
    /// sort all subjects sorted after type and then name
    public func getAllSubjects() -> [UserSubject] {
        let subjects = usersubjects?.allObjects as? [UserSubject] ?? []
        let arr1 = subjects.filter {$0.lk}.sorted(by: {$0.name < $1.name })
        let arr2 = subjects.filter {!$0.lk}.sorted(by: {$0.name < $1.name })
        return arr1+arr2
    }
    
    /// sort all subjects sorted after type and then name
    public func getAllTypes() -> [GradeType] {
        let types = gradetypes?.allObjects as! [GradeType]
        return types.sorted(by: { $0.weigth > $1.weigth})
    }

    @objc(addGradetypesObject:)
    @NSManaged public func addToGradetypes(_ value: GradeType)

    @objc(removeGradetypesObject:)
    @NSManaged public func removeFromGradetypes(_ value: GradeType)

    @objc(addGradetypes:)
    @NSManaged public func addToGradetypes(_ values: NSSet)

    @objc(removeGradetypes:)
    @NSManaged public func removeFromGradetypes(_ values: NSSet)

}

// MARK: Generated accessors for usersubjects
extension AppSettings {

    @objc(addUsersubjectsObject:)
    @NSManaged public func addToUsersubjects(_ value: UserSubject)

    @objc(removeUsersubjectsObject:)
    @NSManaged public func removeFromUsersubjects(_ value: UserSubject)

    @objc(addUsersubjects:)
    @NSManaged public func addToUsersubjects(_ values: NSSet)

    @objc(removeUsersubjects:)
    @NSManaged public func removeFromUsersubjects(_ values: NSSet)

}

extension AppSettings : Identifiable {

}
