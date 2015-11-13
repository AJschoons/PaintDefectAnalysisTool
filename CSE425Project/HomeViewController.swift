//
//  DetailViewController.swift
//  CSE425Project
//
//  Created by adam on 11/10/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit
import CoreData

class HomeViewController: UIViewController {
    
    @IBOutlet weak var startNewAnalysisButton: UIButton!
    @IBOutlet weak var analystNameTextField: UITextField!
    
    private var selectedFactory: Factory?
    private var selectedCheckpoint: Checkpoint?
    private var selectedShift: Shift?
    
    private var factoryTableViewController: FactoryTableViewController!
    private var checkpointTableViewController: CheckpointTableViewController!
    private var shiftTableViewController: ShiftTableViewController!
    
    override func viewWillAppear(animated: Bool) {
        updateStartNewAnalysisButtonEnabledState()
    }
    
    override func viewWillDisappear(animated: Bool) {
        resetStartNewAnalysisForm()
    }
    
    @IBAction func analystNameTextFieldDidChange(sender: AnyObject) {
        updateStartNewAnalysisButtonEnabledState()
    }
    
    private func updateStartNewAnalysisButtonEnabledState() {
        let hasAnalysisInput = (selectedFactory != nil && selectedCheckpoint != nil && selectedShift != nil)
        
        let charsToTrim = NSCharacterSet.whitespaceAndNewlineCharacterSet()
        let trimmedName = analystNameTextField.text?.stringByTrimmingCharactersInSet(charsToTrim)
        let analystNameHasContent = (trimmedName != nil) && (trimmedName!.characters.count > 0)
        
        startNewAnalysisButton.enabled = hasAnalysisInput && analystNameHasContent
    }
    
    private func resetStartNewAnalysisForm() {
        analystNameTextField.text = ""
        
        selectedFactory = nil
        factoryTableViewController.selectedCellIndexPath = nil
        selectedCheckpoint = nil
        checkpointTableViewController.selectedCellIndexPath = nil
        selectedShift = nil
        shiftTableViewController.selectedCellIndexPath = nil
        
        startNewAnalysisButton.enabled = false
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        switch identifier {
        case "newAnalysis":
            // Starting a new analysis
            guard let analyst = analystNameTextField.text, factory = selectedFactory, checkpoint = selectedCheckpoint, shift = selectedShift, destination = segue.destinationViewController as? AnalysisSamplesTableViewController else {
                return
            }
            
            let newAnalysis = Analysis.createInManagedObjectContext()
            newAnalysis.analyst = analyst
            newAnalysis.factory = factory
            newAnalysis.checkpoint = checkpoint
            newAnalysis.shift = shift
            newAnalysis.timeStamp = NSDate() // current date/time
            CoreDataStack.sharedStack.saveContext()
            
            destination.analysis = newAnalysis
            
        case "factoryTableEmbed":
            factoryTableViewController = (segue.destinationViewController as! FactoryTableViewController)
            factoryTableViewController.delegate = self
            
        case "checkpointTableEmbed":
            checkpointTableViewController = (segue.destinationViewController as! CheckpointTableViewController)
            checkpointTableViewController.delegate = self
            
        case "shiftTableEmbed":
            shiftTableViewController = (segue.destinationViewController as! ShiftTableViewController)
            shiftTableViewController.delegate = self
            
        default:
            return
        }
    }
}

extension HomeViewController: FactoryTableViewControllerDelegate {
    func factoryTableViewController(factoryTableViewController: FactoryTableViewController, didSelectFactory factory: Factory) {
        selectedFactory = factory
        updateStartNewAnalysisButtonEnabledState()
    }
}

extension HomeViewController: CheckpointTableViewControllerDelegate {
    func checkpointTableViewController(checkpointTableViewController: CheckpointTableViewController, didSelectCheckpoint checkpoint: Checkpoint) {
        selectedCheckpoint = checkpoint
        updateStartNewAnalysisButtonEnabledState()
    }
}

extension HomeViewController: ShiftTableViewControllerDelegate {
    func shiftTableViewController(shiftTableViewController: ShiftTableViewController, didSelectShift shift: Shift) {
        selectedShift = shift
        updateStartNewAnalysisButtonEnabledState()
    }
}