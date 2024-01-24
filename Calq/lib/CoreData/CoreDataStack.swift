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
                
                if #available(iOS 15.0, *) {
                    if let file = Bundle.main.path(forResource: "gradesBackup", ofType: "json") {
                       // try data.write(to: container.managedObjectModel.entities)
                    }
                    
                    do {
                        let data = try NSKeyedArchiver.archivedData(withRootObject: "eeee", requiringSecureCoding: false)
                        
                    } catch {
                        print("Couldn't write file")
                    }
                    
                    do {
                        try container.persistentStoreCoordinator.destroyPersistentStore(at: storeURL, type: .sqlite) }  catch {
                            fatalError("Unresolved error \(error)") // crash qwq
                        }
                } else {
                    fatalError("Unresolved error #2 \(error)") // crash qwq
                }
                
                container.loadPersistentStores { (store, error) in
                    // Handle errors
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
