//
//  AnalysisSamplesTableViewController.swift
//  CSE425Project
//
//  Created by adam on 11/11/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class AnalysisSamplesTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

extension AnalysisSamplesTableViewController {
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 23
    }
}

extension AnalysisSamplesTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("analysisSampleCell", forIndexPath: indexPath)
        cell.textLabel?.text = "Sample \(indexPath.row)"
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}