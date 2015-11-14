//
//  DefectType.swift
//  CSE425Project
//
//  Created by adam on 11/14/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import CoreData
import UIKit

class DefectType: NSManagedObject {
    static let entityDescriptionName = "DefectType"
    
    @NSManaged var name: String
    @NSManaged var defects: NSSet
    @NSManaged private var colorString: String
    
    private var color: UIColor?
    
    func getColor() -> UIColor {
        if color == nil {
            color = UIColor(rgba: colorString)
        }
        return color!
    }
    
    func setColorWithHexString(hexString: String) {
        colorString = hexString
        color = UIColor(rgba: colorString)
    }
    
    
    class func fetchDefectTypes() -> [DefectType] {
        let context = CoreDataStack.sharedStack.managedObjectContext
        let fetchRequest = NSFetchRequest(entityName: DefectType.entityDescriptionName)
        
        // order alphabetically
        fetchRequest.sortDescriptors = [NSSortDescriptor(key: "name", ascending: true)]
        
        var defectTypes = [DefectType]()
        do {
            defectTypes = try context.executeFetchRequest(fetchRequest) as! [DefectType]
            
            // Is this the first time the program is being run?
            // If so, initialize the DefectTypes
            if defectTypes.count == 0 {
                initializeDefectTypes()
                defectTypes = try context.executeFetchRequest(fetchRequest) as! [DefectType]
            }
        } catch {
            print("Couldn't load DefectTypes")
        }
        
        return defectTypes
    }
    
    private class func initializeDefectTypes() {
        let context = CoreDataStack.sharedStack.managedObjectContext
        
        // 19 types
        let defectTypeNames = ["Missed Prime Defect", "Dry Clear Coat", "Crater", "Other", "Multicoloured dry base", "Skid Dirt", "Fatty Edge", "Mapping", "Paint Sealer", "Base Coat", "Clear Coat", "Weld Expulsion", "Multicoloured Base", "Mottle", "Off colour", "Edge Sanding", "Dry Appearance", "Fiber In Base", "Fiber in Base - White"]
        let defectTypeColors = ["#D24D57", "#96281B", "#CF000F", "#D35400", "#F9690E", "#F2784B", "#FDE3A7", "#F5D76E", "#F7CA18", "#87D37C", "#26A65B", "#16A085", "#C5EFF7", "#4183D7", "#2C3E50", "#89C4F4", "#913D88", "#9A12B3", "#BF55EC", "#DB0A5B"]
        
        // Use this variable to create the DefectTypes
        var defectType: DefectType
        for (index, defectTypeName) in defectTypeNames.enumerate() {
            defectType = NSEntityDescription.insertNewObjectForEntityForName(DefectType.entityDescriptionName, inManagedObjectContext: context) as! DefectType
            defectType.name = defectTypeName
            defectType.setColorWithHexString(defectTypeColors[index])
        }
        
        CoreDataStack.sharedStack.saveContext()
    }
}