//
//  MigrationPolicy.swift
//  Calq
//
//  Created by Kiara on 19.05.23.
//

import CoreData

// FUNCTION($entityPolicy, "typeForIsSaved:", $source.big)
class MigrationV0toV1: NSEntityMigrationPolicy {
    // swiftlint:disable compiler_protocol_init
    @objc func typeFor(isSaved: NSNumber) -> NSNumber {
        if isSaved.boolValue {
            return NSNumber(integerLiteral: 1)
        } else {
            return NSNumber(integerLiteral: 0)
        }
    }
}

// FUNCTION($entityPolicy, "updateWeightOrigWeight:", $source.weigth)
class MigrationV3toV4: NSEntityMigrationPolicy {
    @objc func updateWeight(origWeight: NSNumber) -> Double {
        return Double(origWeight)
    }
}
// swiftlint:enable compiler_protocol_init
