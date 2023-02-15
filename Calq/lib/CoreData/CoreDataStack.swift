import CoreData

class CoreDataStack {
    static let shared = CoreDataStack()
    
    var workingContext: NSManagedObjectContext {
        let context = NSManagedObjectContext(concurrencyType: .privateQueueConcurrencyType)
        context.parent = managedObjectContext
        return context
    }
    
    var managedObjectContext: NSManagedObjectContext {
        persistentContainer.viewContext
    }
    
    private init() {}
    
    private var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Model")
        let storeURL = URL.storeURL()
        let storeDescription = NSPersistentStoreDescription(url: storeURL)
        storeDescription.shouldMigrateStoreAutomatically = true
        container.persistentStoreDescriptions = [storeDescription]
    
        
           container.loadPersistentStores(completionHandler: { (storeDescription, error) in
               if let error = error as NSError? {
                   fatalError("Unresolved error \(error), \(error.userInfo)")
               }
           })
           return container
       }()
    
    func saveContext() {
        managedObjectContext.performAndWait {
            if managedObjectContext.hasChanges {
                do {
                    try managedObjectContext.save()
                } catch {
                    print(error.localizedDescription)
                }
            }
        }
    }
}

public extension URL {
    
    static func storeURL() -> URL {
        guard let fileContainer = FileManager.default.containerURL(forSecurityApplicationGroupIdentifier: "group.CalqRechner") else {
            fatalError("Shared file container could not be created")
        }
        return fileContainer.appendingPathComponent("Model.sqlite")
    }
}
