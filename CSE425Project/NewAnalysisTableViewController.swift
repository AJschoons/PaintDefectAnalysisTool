//
//  NewAuditTableViewController.swift
//  CSE425Project
//
//  Created by adam on 11/10/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class NewAnalysisTableViewController: UITableViewController {

    var selectedCellIndexPath: NSIndexPath?
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        updateCellSelection()
    }
    
    override func viewWillDisappear(animated: Bool) {
        // Clears out the selection
        updateCellSelection()
    }
}

extension NewAnalysisTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCellIndexPath = indexPath
        updateCellSelection()
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        selectedCellIndexPath = nil
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row != 0 // first row is a title, don't select it
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
    }
    
    // gives the selected cell a checkmark
    private func updateCellSelection() {
        for var row = 0; row < tableView.numberOfRowsInSection(0); ++row {
            let indexPath = NSIndexPath(forRow: row, inSection: 0)
            let cell = tableView.cellForRowAtIndexPath(indexPath)
            let accessoryType: UITableViewCellAccessoryType = (indexPath == selectedCellIndexPath) ? .Checkmark : .None
            cell?.accessoryType = accessoryType
        }
    }
}