//
//  MigrationPolicy.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import CoreData

class MigrationV0toV1: NSEntityMigrationPolicy {
    
    @objc func typeFor(isSaved:NSNumber) -> NSNumber {
        if isSaved.boolValue {
            return NSNumber(integerLiteral: 1)
        } else {
            return NSNumber(integerLiteral: 0)
        }
    }
}
//FUNCTION($entityPolicy, "typeForIsSaved:", $source.big)
