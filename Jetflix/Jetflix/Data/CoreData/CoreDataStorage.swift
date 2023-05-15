//
//  CoreDataStorage.swift
//  Jetflix
//
//  Created by 유정주 on 2023/05/15.
//

import CoreData

final class CoreDataStorage {
    static let shared = CoreDataStorage()
    
    private init() { }
    
    // MARK: - Core Data stack
    private lazy var persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "CoreData")
        container.loadPersistentStores { _, error in
            if let error = error as NSError? {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \(error.userInfo)")
            }
        }
        
        return container
    }()
    
    //메인 thread
    lazy var context: NSManagedObjectContext = {
        persistentContainer.viewContext
    }()
    
    //백그라운드 thread
    lazy var backgroundContext: NSManagedObjectContext = {
        persistentContainer.newBackgroundContext()
    }()

    func saveContext() {
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // TODO: - Log to Crashlytics
                assertionFailure("CoreDataStorage Unresolved error \(error), \((error as NSError).userInfo)")
            }
        }
    }

    func performBackgroundTask(_ block: @escaping (NSManagedObjectContext) -> Void) {
        persistentContainer.performBackgroundTask(block)
    }
}
