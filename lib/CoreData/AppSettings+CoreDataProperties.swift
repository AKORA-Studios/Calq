//
//  AppSettings+CoreDataProperties.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//
//

import Foundation
import CoreData


extension AppSettings {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<AppSettings> {
        return NSFetchRequest<AppSettings>(entityName: "AppSettings")
    }

    @NSManaged public var colorfulCharts: Bool
    @NSManaged public var weightBigGrades: String
    @NSManaged public var usersubjects: NSSet?
    @NSManaged public var exam1: UserSubject?
    @NSManaged public var exam2: UserSubject?
    @NSManaged public var exam3: UserSubject?
    @NSManaged public var exam4: UserSubject?
    @NSManaged public var exam5: UserSubject?

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
