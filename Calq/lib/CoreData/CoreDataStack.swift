import CoreData
import UIKit

class CoreDataStack: ImplementsCoreDataStack {
    static let sharedContext = CoreDataStack().managedObjectContext
    
    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    init() {}
    
    lazy private var persistentContainer: NSPersistentContainer = {
        var container = NSPersistentContainer(name: "Model")
        let storeURL = URL.storeURL()
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.shouldInferMappingModelAutomatically = false
        storeDescription.shouldMigrateStoreAutomatically = true
        
        #if APP_WIDGET
         storeDescription.setOption(true as NSNumber, forKey: NSReadOnlyPersistentStoreOption)
        #endif
        
        container.persistentStoreDescriptions = [storeDescription]
        
        container.loadPersistentStores(completionHandler: { (_, error) in
            if let error = error {
                JSON.saveBackup("\(error)")
                UserDefaults.standard.set(true, forKey: UD_repairData)
                
                do {
                    if #available(iOS 15.0, *) {
                        try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, type: .sqlite)
                    } else {
                    }
                } catch {
                    fatalError("Unresolved error \(error)") // crash qwq
                }
                
                container.loadPersistentStores { (_, error2) in
                    fatalError("Unresolved error loading second time \(error2)") // crash qwq
                }
            }
        })
        return container
    }()
}

public extension URL {
    
    static func storeURL() -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.CalqRechner") else {
            fatalError("Shared file container could not be created")
        }
        return fileContainer.appendingPathComponent("Model.sqlite")
    }
}
