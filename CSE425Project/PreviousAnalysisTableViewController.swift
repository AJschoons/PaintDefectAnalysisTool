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
    private var selectedAnalysis: Analysis?
    
    override func viewWillAppear(animated: Bool) {
        // Reload analyses each time the table appears
        analyses = Analysis.fetchAnalyses()
        tableView.reloadData()
        
        selectedAnalysis = nil
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "previousAnalysis" {
            guard let selectedAnalysis = selectedAnalysis, destination = segue.destinationViewController as? AnalysisSamplesTableViewController else {
                return
            }
            
            destination.analysis = selectedAnalysis
        }
    }
}

extension PreviousAnalysisTableViewController {
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let hasData = analyses.count > 0
        
        var numberOfSections = 0
        if hasData {
            numberOfSections = 1
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView = nil
        } else {
            let noDataLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "No Analyses To Show"
            noDataLabel.textAlignment = .Center
            noDataLabel.font = UIFont.systemFontOfSize(12)
            
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .None
        }

        return numberOfSections;
    }
    
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
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // set the selected analysis before the prepareForSegue gets called (didSelect is too late)
        selectedAnalysis = analyses[indexPath.row]
        return indexPath
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}