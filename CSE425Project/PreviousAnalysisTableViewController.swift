//
//  PreviousAuditTableViewController.swift
//  CSE425Project
//
//  Created by adam on 11/10/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class PreviousAnalysisTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension PreviousAnalysisTableViewController {
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 23
    }
}

extension PreviousAnalysisTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
        cell.selectionStyle = .None
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("previousAnalysis", forIndexPath: indexPath)
        cell.textLabel?.text = "Previous Analysis \(indexPath.row)"
        return cell;
    }
}