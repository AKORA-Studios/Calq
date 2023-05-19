//
//  GradeType+CoreDataProperties.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//
//

import Foundation
import CoreData


extension GradeType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GradeType> {
        return NSFetchRequest<GradeType>(entityName: "GradeType")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String?
    @NSManaged public var weigth: Int16

}

extension GradeType : Identifiable {

}
