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
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var finishDateLabel: UILabel!
    @IBOutlet weak var factoryLabel: UILabel!
    @IBOutlet weak var analystLabel: UILabel!
    @IBOutlet weak var checkpointLabel: UILabel!
    @IBOutlet weak var shiftLabel: UILabel!

    // bar buttons are strong references so the ones that aren't showing aren't lost
    @IBOutlet var addBarButton: UIBarButtonItem!
    @IBOutlet var spacerBarButton: UIBarButtonItem!
    @IBOutlet var printReportBarButton: UIBarButtonItem!
    @IBOutlet var finishBarButton: UIBarButtonItem!
    
    var analysis: Analysis!
    
    // used to store which sample was selected so it can be passed in segue
    // should be reset whenever passed to the view controller needing it
    private var selectedSample: Sample?
    
    let textColorForDone = UIColor(rgba: "#16A085")
    let textColorForNotDone = UIColor.redColor()
    
    @IBAction func onFinishButton(sender: AnyObject) {
        analysis.finish = NSDate()
        CoreDataStack.sharedStack.saveContext()
        updateAnalysisDescriptionLabels()
        setRightBarButtons()
    }
    
    @IBAction func onPrintReportButton(sender: AnyObject) {
        
    }
    
    override func viewDidLoad() {
        updateAnalysisDescriptionLabels()
        setRightBarButtons()
    }
    
    override func viewWillAppear(animated: Bool) {
        tableView.reloadData()
    }
    
    private func updateAnalysisDescriptionLabels() {
        startDateLabel.text = "Start: \(dateFormatter.stringFromDate(analysis.start))"
        factoryLabel.text = "Factory: \(analysis.factory.name)"
        analystLabel.text = "Analyst: \(analysis.analyst)"
        checkpointLabel.text = "Checkpoint: \(analysis.checkpoint.rawValue)"
        shiftLabel.text = "Shift: \(analysis.shift)"
        
        let finishTimeText = (analysis.finish != nil) ? dateFormatter.stringFromDate(analysis.finish!) : "(In progress)"
        finishDateLabel.text = "Finish: \(finishTimeText)"
    }
    
    private func setRightBarButtons() {
        let buttonToShow = (analysis.finish == nil) ? finishBarButton : printReportBarButton
        navigationItem.rightBarButtonItems = [addBarButton, spacerBarButton, buttonToShow]
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
            
        } else if identifier == "createReport" {
            guard let navController = segue.destinationViewController as? UINavigationController else { return }
            guard let destination = navController.viewControllers[0] as? ReportViewController else { return }
            
            destination.analysis = analysis
        }
    }
}

extension AnalysisSamplesTableViewController {
    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        let hasData = analysis.getSamplesArray().count > 0
        
        var numberOfSections = 0
        if hasData {
            numberOfSections = 1
            tableView.separatorStyle = .SingleLine
            tableView.backgroundView = nil
        } else {
            let noDataLabel = UILabel(frame: CGRectMake(0, 0, tableView.bounds.size.width, tableView.bounds.size.height))
            noDataLabel.text = "No Samples To Show"
            noDataLabel.textAlignment = .Center
            noDataLabel.font = UIFont.systemFontOfSize(14)
            
            tableView.backgroundView = noDataLabel
            tableView.separatorStyle = .None
        }
        
        return numberOfSections;
    }
    
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
        cell.textLabel?.text = "Sample \(indexPath.row + 1), Model: \(sampleModelText), Left: \(leftSideText), Right: \(rightSideText)"
        
        let isSampleDone = sample.leftSideDone && sample.rightSideDone
        cell.textLabel?.textColor = isSampleDone ? textColorForDone : textColorForNotDone
        
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}