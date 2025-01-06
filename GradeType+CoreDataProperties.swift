//
//  GradeType+CoreDataProperties.swift
//  Calq
//
//  Created by Kiara on 06.01.25.
//
//

import Foundation
import CoreData


extension GradeType {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<GradeType> {
        return NSFetchRequest<GradeType>(entityName: "GradeType")
    }

    @NSManaged public var id: Int16
    @NSManaged public var name: String
    @NSManaged public var weigth: Double
    @NSManaged public var gradetosettings: AppSettings?

}

extension GradeType : Identifiable {

}
