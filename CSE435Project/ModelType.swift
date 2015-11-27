//
//  ModelType.swift
//  CSE435Project
//
//  Created by adam on 11/19/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import CoreData
import UIKit

class ModelType: NSManagedObject {

    static let entityDescriptionName = "ModelType"
    
    @NSManaged var name: String
    
    class func fetchModelTypes() -> [ModelType] {
        let context = CoreDataStack.sharedStack.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: ModelType.entityDescriptionName)
        
        // order alphabetically
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        var modelTypes = [ModelType]()
        do {
            modelTypes = try context.executeFetchRequest(fetchRequest) as! [ModelType]
            
            // Is this the first time the program is being run?
            // If so, initialize the ModelTypes
            if modelTypes.count == 0 {
                initializeModelTypes()
                modelTypes = try context.executeFetchRequest(fetchRequest) as! [ModelType]
            }
        } catch {
            print("Couldn't load ModelTypes")
        }
        
        return modelTypes
    }
    
    private class func initializeModelTypes() {
        let context = CoreDataStack.sharedStack.managedObjectContext
        
        let modelTypeNames = ["Chrysler 200", "Chrysler 300", "Chrysler T&C", "Dodge Grand Caravan", "Dodge Challenger", "Dodge Charger", "Dodge Viper", "Dodge Durango", "Dodge Dart", "Dodge Journey", "Jeep Wrangler", "Jeep Patroit"]
        
        // Use this variable to create the ModelTypes
        var modelType: ModelType
        for modelTypeName in modelTypeNames {
            modelType = NSEntityDescription.insertNewObjectForEntityForName(ModelType.entityDescriptionName, inManagedObjectContext: context) as! ModelType
            modelType.name = modelTypeName
        }
        
        CoreDataStack.sharedStack.saveContext()
    }
}