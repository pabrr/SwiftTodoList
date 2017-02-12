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
    
    
    func initing () -> [NSManagedObject] {
        var myLists: [NSManagedObject] = []
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return myLists
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "STList")
        
        
        do {
            myLists = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }

        return myLists
    }
    
    func saveChanges(becoming: Bool, forString: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "STList")
        fetchRequest.predicate = NSPredicate(format: "todo == %@ AND isFinished == %@", forString, NSNumber(booleanLiteral: !becoming))
        
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
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "STList", in: managedContext)!
        let newEntity = NSManagedObject(entity: entity, insertInto: managedContext)
        
        newEntity.setValue(todo, forKeyPath: "todo")
        newEntity.setValue(false, forKey: "isFinished")
        
        do {
            try managedContext.save()
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    func deleteTodo(todo: String, isDone: Bool) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "STList")
        
        fetchRequest.predicate = NSPredicate(format: "todo == %@ AND isFinished == %@", todo, NSNumber(booleanLiteral: isDone))
        let result = try? managedContext.fetch(fetchRequest)
        if result?.count != 0 {
            managedContext.delete((result?[0])!)
        }
    }
}
