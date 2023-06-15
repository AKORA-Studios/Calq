//
//  CoreDataStack.swift
//  CalqTests
//
//  Created by Kiara on 08.06.23.
//

import CoreData
@testable import Calq

class TestCoreDataStack: ImplementsCoreDataStack {
    static let sharedContext = TestCoreDataStack().managedObjectContext
    
    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {}
    
    private var persistentContainer: NSPersistentContainer = {
        
        
        guard let mom = NSManagedObjectModel.mergedModel(from: [ModelKit.bundle]) else {
            fatalError("Failed to create mom")
        }
        let container = NSPersistentContainer(name: "Model", managedObjectModel: mom)
        
        
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType // important
        storeDescription.url = URL(fileURLWithPath: "/dev/null")
        storeDescription.shouldInferMappingModelAutomatically = false
        storeDescription.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}
