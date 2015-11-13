//
//  Factory.swift
//  CSE425Project
//
//  Created by adam on 11/12/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit
import CoreData

// The checkpoints of a factory
enum Checkpoint: String {
    case ECoat = "E-Coat"
    case Primer = "Primer"
    case TopCoat = "Top Coat"
}

// The shifts of a factory
enum Shift: String {
    case Morning, Afternoon, Evening
}

class Factory: NSManagedObject {
    static let entityDescriptionName = "Factory"
    
    @NSManaged var id: Int16
    @NSManaged var name: String
    
    @NSManaged var analyses: NSSet
    
    class func fetchFactories() -> [Factory] {
        let context = CoreDataStack.sharedStack.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: Factory.entityDescriptionName)
        
        // order alphabetically
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        var factories = [Factory]()
        do {
            factories = try context.executeFetchRequest(fetchRequest) as! [Factory]
            
            // Is this the first time the program is being run?
            // If so, initialize the Factories
            if factories.count == 0 {
                initializeFactories()
                factories = try context.executeFetchRequest(fetchRequest) as! [Factory]
            }
        } catch {
            print("Couldn't load factories")
        }
        
        return factories
    }
    
    private class func initializeFactories() {
        let context = CoreDataStack.sharedStack.managedObjectContext
        
        // Use this variable to create the factories
        var factory = NSEntityDescription.insertNewObjectForEntityForName(Factory.entityDescriptionName, inManagedObjectContext: context) as! Factory
        
        // Factory 1
        factory.name = "Lansing West"
        factory.id = 0
        
        // Factory 2
        factory = NSEntityDescription.insertNewObjectForEntityForName(Factory.entityDescriptionName, inManagedObjectContext: context) as! Factory
        factory.name = "Lansing Oldtown"
        factory.id = 1
        
        // Factory 3
        factory = NSEntityDescription.insertNewObjectForEntityForName(Factory.entityDescriptionName, inManagedObjectContext: context) as! Factory
        factory.name = "Delta Township"
        factory.id = 2
        
        CoreDataStack.sharedStack.saveContext()
    }
}
