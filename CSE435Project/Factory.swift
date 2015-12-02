//
//  Factory.swift
//  CSE435Project
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

enum FactoryLocation: Int16 {
    case LansingDeltaTownship = 1, LansingGrandRiver, LakeOrion
}

class Factory: NSManagedObject {
    static let entityDescriptionName = "Factory"
    
    @NSManaged private var location: Int16
    @NSManaged var name: String
    
    @NSManaged var analyses: NSSet
    
    // The models this factory has
    @NSManaged private var models: NSOrderedSet
    
    func getLocation() -> FactoryLocation {
        return FactoryLocation(rawValue: location)!
    }
    
    // Get the models this factory has
    func getModels() -> [ModelType] {
        return models.array as! [ModelType]
    }
    
    func addModel(model: ModelType) {
        let mutableModels = models.mutableCopy() as! NSMutableOrderedSet
        mutableModels.addObject(model)
        models = mutableModels.copy() as! NSOrderedSet
    }
    
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
        factory.name = "Lansing Delta Township"
        factory.location = FactoryLocation.LansingDeltaTownship.rawValue
        ModelType.initializeModelTypesForFactory(factory)
        
        // Factory 2
        factory = NSEntityDescription.insertNewObjectForEntityForName(Factory.entityDescriptionName, inManagedObjectContext: context) as! Factory
        factory.name = "Lansing Grand River"
        factory.location = FactoryLocation.LansingGrandRiver.rawValue
        ModelType.initializeModelTypesForFactory(factory)
        
        // Factory 3
        factory = NSEntityDescription.insertNewObjectForEntityForName(Factory.entityDescriptionName, inManagedObjectContext: context) as! Factory
        factory.name = "Lake Orion"
        factory.location = FactoryLocation.LakeOrion.rawValue
        ModelType.initializeModelTypesForFactory(factory)
        
        CoreDataStack.sharedStack.saveContext()
    }
}
