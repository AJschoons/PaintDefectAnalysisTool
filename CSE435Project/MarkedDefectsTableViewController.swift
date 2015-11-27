//
//  MarkedDefectsTableViewController.swift
//  CSE435Project
//
//  Created by adam on 11/11/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class MarkedDefectsTableViewController: UITableViewController {
    
    var sample: Sample!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension MarkedDefectsTableViewController {
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let hasData = sample.getDefectsArray().count > 0
        
        var numberOfSections = 0
        if hasData {
            numberOfSections = 1
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView = nil
        } else {
            let noDataLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "No Marked Defects To Show"
            noDataLabel.textAlignment = .Center
            noDataLabel.font = UIFont.systemFontOfSize(14)
            
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .None
        }
        
        return numberOfSections;
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sample.getDefectsArray().count
    }
}

extension MarkedDefectsTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("markedDefectCell", forIndexPath: indexPath)
        
        let defect = sample.getDefectsArray()[indexPath.row]

        cell.textLabel?.text = "Defect \(indexPath.row + 1), Type: \(defect.type.name), Severity: \(defect.severity.toString()), Sample Side: \(defect.drawingSide.toString()), Region: \(defect.region.toString())"
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}