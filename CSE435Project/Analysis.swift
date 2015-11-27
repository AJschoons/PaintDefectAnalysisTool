//
//  Analysis.swift
//  CSE435Project
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
    @NSManaged var start: NSDate
    @NSManaged var finish: NSDate?
    @NSManaged private var samples: NSOrderedSet
    
    // factory the analysis was performed in
    @NSManaged var factory: Factory
    
    var checkpoint: Checkpoint {
        get {
            return Checkpoint(rawValue: checkpointString)!
        }
        set(newCheckpoint) {
            checkpointString = newCheckpoint.rawValue
        }
    }
    
    var shift: Shift {
        get {
            return Shift(rawValue: shiftString)!
        }
        set(newShift) {
            shiftString = newShift.rawValue
        }
    }
    
    func addSample(sample: Sample) {
        let samplesSet = mutableOrderedSetValueForKey("samples")
        samplesSet.addObject(sample)
    }
    
    func removeSample(sample: Sample) {
        let samplesSet = mutableOrderedSetValueForKey("samples")
        samplesSet.removeObject(sample)
    }
    
    func getSamplesArray() -> [Sample] {
        return samples.array as! [Sample]
    }
    
    func toString() -> String {
        return "\(dateFormatter.stringFromDate(start))     \(factory.name)-->\(checkpointString)-->\(shiftString)      Analyst: \(analyst)"
    }
    
    func toFilenameString() -> String {
        return "\(filenameDateFormatter.stringFromDate(start))_\(factory.name)_\(checkpointString)_\(shiftString)"
    }
    
    func toCsvString() -> String {
        var csvString = ""
        csvString += "Factory,Checkpoint,Shift,Analyst,Start,Finish\n"
        csvString += "\(factory.name),\(checkpoint.rawValue),\(shift.rawValue),\(analyst),\"\(dateFormatter.stringFromDate(start))\",\"\(dateFormatter.stringFromDate(finish!))\"\n"
        csvString += ",,,,,\n"
        csvString += "Defects,,,,,\n"
        csvString += "Type,Severity,Model,Region,Plane,Side\n"
        
        for sample in getSamplesArray() {
            for defect in sample.getDefectsArray() {
                csvString += "\(defect.type.name),\(defect.severity.toString()),\(sample.model!.name),\(defect.region.toString()),\(defect.plane.toString()),\(defect.side.toString())\n"
            }
        }
        
        return csvString
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
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "start", ascending: false)]
        
        var analyses = [Analysis]()
        do {
            analyses = try context.executeFetchRequest(fetchRequest) as! [Analysis]
        } catch {
            print("Couldn't load analyses")
        }
        
        return analyses
    }
}
