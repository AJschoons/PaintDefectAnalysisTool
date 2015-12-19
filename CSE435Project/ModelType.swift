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
    
    @NSManaged private(set) var name: String
    
    class func initializeModelTypesForFactory(factory: Factory) {
        let context = CoreDataStack.sharedStack.managedObjectContext
        
        var modelTypeNames = [String]()
        switch factory.getLocation() {
        case .LakeOrion:
            modelTypeNames = ["Chevrolet Sonic 4 door", "Chevrolet Sonic 5 door", "Buick Verano"]
        case .LansingDeltaTownship:
            modelTypeNames = ["Chevrolet Traverse", "Buick Enclave", "GMC Acadia"]
        case .LansingGrandRiver:
            modelTypeNames = ["Cadillac ATS", "Cadillac CTS 4 door", "Cadillac CTS Coupe", "Chevrolet Camaro"]
        }
        
        modelTypeNames.sortInPlace()
        
        // Use this variable to create the ModelTypes
        var modelType: ModelType
        for modelTypeName in modelTypeNames {
            modelType = NSEntityDescription.insertNewObjectForEntityForName(ModelType.entityDescriptionName, inManagedObjectContext: context) as! ModelType
            modelType.name = modelTypeName
            factory.addModel(modelType)
        }
        
        CoreDataStack.sharedStack.saveContext()
    }
}