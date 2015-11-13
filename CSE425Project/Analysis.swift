//
//  Analysis.swift
//  CSE425Project
//
//  Created by adam on 11/12/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit
import CoreData

class Analysis: NSManagedObject {
    static let entityDescriptionName = "Analysis"
    
    @NSManaged var analyst: String
    @NSManaged private var checkpointString: String
    @NSManaged private var shiftString: String
    @NSManaged var timeStamp: NSDate
    
    // factory the analysis was performed in
    @NSManaged var factory: Factory
    
    var checkpoint: Checkpoint? {
        get {
            return Checkpoint(rawValue: checkpointString)
        }
        set(newCheckpoint) {
            checkpointString = (newCheckpoint?.rawValue)!
        }
    }
    
    var shift: Shift? {
        get {
            return Shift(rawValue: shiftString)
        }
        set(newShift) {
            shiftString = (newShift?.rawValue)!
        }
    }
    
    func toString() -> String {
        return "\(dateFormatter.stringFromDate(timeStamp))     \(factory.name)-->\(checkpointString)-->\(shiftString)      Analyst: \(analyst)"
    }
    
    class func createInManagedObjectContext() -> Analysis {
        let analysis = NSEntityDescription.insertNewObjectForEntityForName(Analysis.entityDescriptionName, inManagedObjectContext: CoreDataStack.sharedStack.managedObjectContext) as! Analysis
        CoreDataStack.sharedStack.saveContext()
        return analysis
    }
    
    class func fetchAnalyses() -> [Analysis] {
        let context = CoreDataStack.sharedStack.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: Analysis.entityDescriptionName)
        
        // order by time created; most recent are first in array
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "timeStamp", ascending: false)]
        
        var analyses = [Analysis]()
        do {
            analyses = try context.executeFetchRequest(fetchRequest) as! [Analysis]
        } catch {
            print("Couldn't load analyses")
        }
        
        return analyses
    }
}
