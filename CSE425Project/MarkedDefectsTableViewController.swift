//
//  MarkedDefectsTableViewController.swift
//  CSE425Project
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
        cell.textLabel?.text = "Marked Defect \(indexPath.row)"
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}