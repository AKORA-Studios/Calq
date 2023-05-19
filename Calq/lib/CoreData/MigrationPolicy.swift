//
//  MigrationPolicy.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import CoreData

class MigrationV0toV1: NSEntityMigrationPolicy {
    @objc func typeFor(isLK:NSNumber) -> NSNumber {
         if isLK.boolValue {
             return NSNumber(integerLiteral: 1)
         } else {
             return NSNumber(integerLiteral: 0)
         }
     }
    
    @objc func convert(isLK: Bool) -> Int16 {
        return isLK ? 1 : 0;
    }
}
//FUNCTION($entityPolicy, "typeForisLK:", $source.big)
