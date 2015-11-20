//
//  AnalysisSamplesTableViewController.swift
//  CSE425Project
//
//  Created by adam on 11/11/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class AnalysisSamplesTableViewController: UITableViewController {
    
    // analysis description labels
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var factoryLabel: UILabel!
    @IBOutlet weak var analystLabel: UILabel!
    @IBOutlet weak var checkpointLabel: UILabel!
    @IBOutlet weak var shiftLabel: UILabel!

    var analysis: Analysis!
    
    // used to store which sample was selected so it can be passed in segue
    // should be reset whenever passed to the view controller needing it
    private var selectedSample: Sample?
    
    override func viewDidLoad() {
        updateAnalysisDescriptionLabels()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    func updateAnalysisDescriptionLabels() {
        dateLabel.text = "Date: \(dateFormatter.stringFromDate(analysis.timeStamp))"
        factoryLabel.text = "Factory: \(analysis.factory.name)"
        analystLabel.text = "Analyst: \(analysis.analyst)"
        checkpointLabel.text = "Checkpoint: \(analysis.checkpoint)"
        shiftLabel.text = "Shift: \(analysis.shift)"
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "addNewSample" {
            guard let navController = segue.destinationViewController as? UINavigationController else { return }
            guard let destination = navController.viewControllers[0] as? CarSampleViewController else { return }
            
            destination.isNewSample = true
            destination.analysis = analysis
            
            let sample = Sample.createInManagedObjectContext()
            analysis.addSample(sample)
            destination.sample = sample
            
        } else if identifier == "viewSample" {
            guard let destination = segue.destinationViewController as? CarSampleViewController else { return }
            
            destination.isNewSample = false
            destination.analysis = analysis
            destination.sample = selectedSample
            selectedSample = nil
        }
    }
}

extension AnalysisSamplesTableViewController {
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return analysis.getSamplesArray().count
    }
}

extension AnalysisSamplesTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, willSelectRowAtIndexPath indexPath: NSIndexPath) -> NSIndexPath? {
        // intercept the message before the table selects the row so we can set the selectedSample before the segue
        // didSelect gets called too late
        selectedSample = analysis.getSamplesArray()[indexPath.row]
        
        return indexPath
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("analysisSampleCell", forIndexPath: indexPath)
        
        let sample = analysis.getSamplesArray()[indexPath.row]
        
        let sampleModelText = (sample.model != nil) ? sample.model!.name : "N/A"
        let leftSideText = sample.leftSideDone ? "Done" : "Not Done"
        let rightSideText = sample.rightSideDone ? "Done" : "Not Done"
        cell.textLabel?.text = "Sample \(indexPath.row), Model: \(sampleModelText), Left: \(leftSideText), Right: \(rightSideText)"
        
        let isSampleDone = sample.leftSideDone && sample.rightSideDone
        cell.textLabel?.textColor = isSampleDone ? UIColor.greenColor() : UIColor.redColor()
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}