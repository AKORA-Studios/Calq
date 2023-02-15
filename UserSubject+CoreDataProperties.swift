//
//  UserSubject+CoreDataProperties.swift
//  Calq
//
//  Created by Kiara on 15.02.23.
//
//

import Foundation
import CoreData


extension UserSubject {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserSubject> {
        return NSFetchRequest<UserSubject>(entityName: "UserSubject")
    }

    @NSManaged public var color: String
    @NSManaged public var exampoints: Int16
    @NSManaged public var examtype: Int16
    @NSManaged public var inactiveYears: String
    @NSManaged public var lk: Bool
    @NSManaged public var name: String
    @NSManaged public var subjecttests: NSSet?
    @NSManaged public var subjecttosettings: AppSettings

}

// MARK: Generated accessors for subjecttests
extension UserSubject {

    @objc(addSubjecttestsObject:)
    @NSManaged public func addToSubjecttests(_ value: UserTest)

    @objc(removeSubjecttestsObject:)
    @NSManaged public func removeFromSubjecttests(_ value: UserTest)

    @objc(addSubjecttests:)
    @NSManaged public func addToSubjecttests(_ values: NSSet)

    @objc(removeSubjecttests:)
    @NSManaged public func removeFromSubjecttests(_ values: NSSet)

}

extension UserSubject : Identifiable {

}
