//
//  PreviousAuditTableViewController.swift
//  CSE425Project
//
//  Created by adam on 11/10/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class PreviousAnalysisTableViewController: UITableViewController {

    private var analyses = [Analysis]()
    
    override func viewWillAppear(animated: Bool) {
        // Reload analyses each time the table appears
        analyses = Analysis.fetchAnalyses()
        tableView.reloadData()
    }
}

extension PreviousAnalysisTableViewController {
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analyses.count
    }
}

extension PreviousAnalysisTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("previousAnalysis", forIndexPath: indexPath)
        cell.textLabel?.text = analyses[indexPath.row].toString()
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}