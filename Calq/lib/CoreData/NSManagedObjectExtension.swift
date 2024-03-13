//
//  NSManagedObjectExtension.swift
//  Calq
//
//  Created by Kiara on 13.03.24.
//

import CoreData

// CoreData warning: Multiple NSEntityDescriptions claim the NSManagedObject subclass
extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
