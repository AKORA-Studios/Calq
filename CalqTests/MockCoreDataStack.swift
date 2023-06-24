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
        let container = NSPersistentContainer(name: "TestContainer", managedObjectModel: mom)
        
        let storeDescription = NSPersistentStoreDescription()
        storeDescription.type = NSInMemoryStoreType // important
        storeDescription.url = URL(fileURLWithPath: "/dev/null")
        storeDescription.shouldInferMappingModelAutomatically = false
        storeDescription.shouldMigrateStoreAutomatically = true
        storeDescription.shouldAddStoreAsynchronously = false
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
}

// move to nnormal coredata stack to remove warnings hm
public extension NSManagedObject {
    convenience init(context: NSManagedObjectContext) {
        let name = String(describing: type(of: self))
        let entity = NSEntityDescription.entity(forEntityName: name, in: context)!
        self.init(entity: entity, insertInto: context)
    }
}
