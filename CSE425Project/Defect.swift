//
//  Defect.swift
//  CSE425Project
//
//  Created by adam on 11/25/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import CoreData
import UIKit

// The region on a car the defect is on
enum DefectRegion: Int16 {
    case LeftVertical = 1, RightVertical, Roof, Hood, Deck
    
    func toString() -> String {
        switch self {
        case .LeftVertical:
            return "Left Vertical"
        case .RightVertical:
            return "Right Vertical"
        case .Roof:
            return "Roof"
        case .Hood:
            return "Hood"
        case .Deck:
            return "Deck"
        }
    }
}

// The severity of the defect
enum DefectSeverity: Int16 {
    case Low = 1, Moderate, High
}

// The spatial plane of the defect
enum DefectPlane: Int16 {
    case Horizontal = 1, Vertical
}

// The left-right side of the car the defect is on
enum DefectSide: Int16 {
    case Left = 1, Right
    
    func toString() -> String {
        switch self {
        case .Left:
            return "Left"
        case .Right:
            return "Right"
        }
    }
}

// Location will be a scaled 0-1 value, must be multiplied by corresponding sample size
struct DefectLocation {
    var x: Double
    var y: Double
}

class Defect: NSManagedObject {
    static let entityDescriptionName = "Defect"
    
    @NSManaged var type: DefectType
    @NSManaged private var severityInt: Int16
    @NSManaged private var regionInt: Int16
    @NSManaged private var planeInt: Int16
    @NSManaged private var sideInt: Int16
    @NSManaged private var drawingSideInt: Int16
    @NSManaged private var locationX: Double
    @NSManaged private var locationY: Double
    
    var severity: DefectSeverity {
        get { return DefectSeverity(rawValue: severityInt)! }
        set { severityInt = newValue.rawValue }
    }
    
    var region: DefectRegion {
        get { return DefectRegion(rawValue: regionInt)! }
        set { regionInt = newValue.rawValue }
    }
    
    var plane: DefectPlane {
        get { return DefectPlane(rawValue: planeInt)! }
        set { planeInt = newValue.rawValue }
    }
    
    var side: DefectSide {
        get { return DefectSide(rawValue: sideInt)! }
        set { sideInt = newValue.rawValue }
    }
    
    // The side image of a car the defect should be drawn on
    var drawingSide: SampleSide {
        get { return SampleSide(rawValue: drawingSideInt)! }
        set { drawingSideInt = newValue.rawValue }
    }
    
    func getScaledLocation() -> DefectLocation {
        return DefectLocation(x: locationX, y: locationY)
    }
    
    func setScaledLocation(x: Double, y: Double) {
        guard x >= 0 && x <= 1 && y >= 0 && y <= 1 else {
            print("X and Y values must be 0-1 inclusive; could not set")
            return
        }
        
        locationX = x
        locationY = y
    }
    
    class func createInManagedObjectContext() -> Defect {
        let defect = NSEntityDescription.insertNewObjectForEntityForName(Defect.entityDescriptionName, inManagedObjectContext: CoreDataStack.sharedStack.managedObjectContext) as! Defect
        CoreDataStack.sharedStack.saveContext()
        return defect
    }
}
