//
//  STCoredata.swift
//  SwiftTodo
//
//  Created by Полина Абросимова on 11.02.17.
//  Copyright © 2017 Полина Абросимова. All rights reserved.
//

import Foundation
import UIKit
import CoreData

class CoreData {
    
    static let sharedInstance = CoreData()
    
    private init() {}
    
    private var persistentContainer: NSPersistentContainer = {
        
        let container = NSPersistentContainer(name: "SwiftTodo")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()
    
    
    func initing () -> [NSManagedObject] {
        var myLists: [NSManagedObject] = []
        
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "STList")
        
        
        do {
            myLists = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return myLists
    }
    
    func saveChanges(becoming: Bool, forString: String, withIdentifier: String) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "STList")
        fetchRequest.predicate = NSPredicate(format: "todo == %@ AND isFinished == %@ AND identifier == %@", forString, NSNumber(booleanLiteral: !becoming), withIdentifier)
    
        let result = try? managedContext.fetch(fetchRequest)
        
        if result?.count != 0 {
            let managedObject = result?[0] as! STList
            managedObject.setValue(becoming, forKey: "isFinished")
            do {
                try managedContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
    
    func saveNewTodo(todo: String) {
        let managedContext = persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "STList", in: managedContext)!
        let newEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        let uuid = NSUUID().uuidString
        
        newEntity.setValue(todo, forKeyPath: "todo")
        newEntity.setValue(false, forKey: "isFinished")
        newEntity.setValue(uuid, forKey: "identifier")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTodo(todo: String, isDone: Bool, identifier: String) {
        let managedContext = persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "STList")
        
        fetchRequest.predicate = NSPredicate(format: "todo == %@ AND isFinished == %@ AND identifier == %@", todo, NSNumber(booleanLiteral: isDone), identifier)
        let result = try? managedContext.fetch(fetchRequest)
        if result?.count != 0 {
            managedContext.delete((result?[0])!)
            do {
                try managedContext.save()
            } catch {
                fatalError("Failure to save context: \(error)")
            }
        }
    }
}
