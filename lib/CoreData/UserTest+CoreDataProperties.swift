//
//  UserTest+CoreDataProperties.swift
//  Calq
//
//  Created by Kiara on 03.02.23.
//
//

import Foundation
import CoreData


extension UserTest {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<UserTest> {
        return NSFetchRequest<UserTest>(entityName: "UserTest")
    }

    @NSManaged public var big: Bool
    @NSManaged public var date: Date
    @NSManaged public var grade: Int16
    @NSManaged public var name: String
    @NSManaged public var year: Int16
    @NSManaged public var testtosubbject: UserSubject

}

extension UserTest : Identifiable {

}
