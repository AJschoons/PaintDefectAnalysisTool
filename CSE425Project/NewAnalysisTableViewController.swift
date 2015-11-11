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
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension NewAnalysisTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if indexPath == selectedCellIndexPath {
            performDeselectionActionsForRowAtIndexPath(indexPath)
        } else {
            tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = UITableViewCellAccessoryType.Checkmark
            selectedCellIndexPath = indexPath
        }
    }
    
    override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        performDeselectionActionsForRowAtIndexPath(indexPath)
    }
    
    func performDeselectionActionsForRowAtIndexPath(indexPath: NSIndexPath) {
        tableView.cellForRowAtIndexPath(indexPath)?.accessoryType = .None
        selectedCellIndexPath = nil
    }
    
    override func tableView(tableView: UITableView, shouldHighlightRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        return indexPath.row != 0 // first row is a title, don't select it
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
    }
}