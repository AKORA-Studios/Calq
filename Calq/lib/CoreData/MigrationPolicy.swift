//
//  MigrationPolicy.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import CoreData

class MigrationV0toV1: NSEntityMigrationPolicy {
    @objc func typeFor(isLK:Bool) -> Int16 {
        return isLK ? 1 : 0
     }
}
//FUNCTION($entityPolicy, "typeForisLK:", $source.big)
