//
//  CarSampleViewController.swift
//  CSE425Project
//
//  Created by adam on 11/11/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class CarSampleViewController: UIViewController {
    
    @IBOutlet weak var backBarButton: UIBarButtonItem!
    @IBOutlet var doneBarButton: UIBarButtonItem! // not a weak reference so still retained when not shown
    
    @IBOutlet weak var chooseModelButton: UIButton!
    
    // car selection area
    @IBOutlet weak var carSideSegmentedControl: UISegmentedControl!
    @IBOutlet weak var carLeftSideView: UIView!
    @IBOutlet weak var carTopSideView: UIView!
    @IBOutlet weak var carRightSideView: UIView!
    private var carSideViews = [UIView]()
    @IBOutlet weak var defectMarkView: DefectMarkView!
    
    @IBOutlet weak var defectPickerView: UIPickerView!
    private var defectTypes = [DefectType]()
    
    @IBOutlet weak var leftSideSwitch: UISwitch!
    @IBOutlet weak var rightSideSwitch: UISwitch!
    
    var analysis: Analysis!
    var sample: Sample!
    var isNewSample: Bool!
    
    private(set) var selectedDefectType: DefectType!
    private func setSelectedDefectType(defectType: DefectType) {
        selectedDefectType = defectType
        defectMarkView.setCurrentlySelectedDefectType(defectType)
    }
    
    private var selectedModelType: ModelType?
    private func setSelectedModelType(modelType: ModelType) {
        selectedModelType = modelType
        sample.model = selectedModelType
        updateChooseModelButton()
    }
    
    @IBAction func onBackBarButton(sender: AnyObject) {
        if isNewSample! {
            // remove the sample, since this button says "Cancel" for new samples
            analysis.removeSample(sample)
            CoreDataStack.sharedStack.saveContext()
            
            // modally presented for a new sample
            dismissViewControllerAnimated(true, completion: nil)
        } else {
            // save the changed sample data
            CoreDataStack.sharedStack.saveContext()
            
            // when view a sample it's pushed instead of modally presented
            navigationController?.popViewControllerAnimated(true)
        }
    }
    
    @IBAction func onDoneBarButton(sender: AnyObject) {
        guard isNewSample! else { return } // done button shouldn't be there when viewing a previous sample
        
        // save the new sample so it persists
        CoreDataStack.sharedStack.saveContext()
        
        // modally presented for a new sample
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func leftSwitchValueDidChange(sender: AnyObject) {
        sample.leftSideDone = leftSideSwitch.on
    }
    
    @IBAction func rightSwitchValueDidChange(sender: AnyObject) {
        sample.rightSideDone = rightSideSwitch.on
    }
    
    @IBAction func carSideSegmentedControlIndexDidChange(sender: AnyObject) {
        updateVisibleCarSide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carSideViews = [carLeftSideView, carTopSideView, carRightSideView]
        
        // initialize the visible car side image
        updateVisibleCarSide()
        
        // load the defect types
        defectTypes = DefectType.fetchDefectTypes()
        
        // setup picker view
        centerWheelForDefectPickerView(defectPickerView)
        
        if isNewSample! {
            backBarButton.title = "Cancel"
        } else {
            initializeUIWithSample()
            navigationItem.rightBarButtonItems = nil // don't show the "Done" button
        }
    }
    
    private func initializeUIWithSample() {
        if sample.model != nil {
            setSelectedModelType(sample.model!)
        }
        
        leftSideSwitch.on = sample.leftSideDone
        rightSideSwitch.on = sample.rightSideDone
    }
    
    
    // only show the car side that is currently selected; hide all the others
    private func updateVisibleCarSide() {
        for (index, carSideView) in carSideViews.enumerate() {
            let shouldHideCarSideView = (index != carSideSegmentedControl.selectedSegmentIndex)
            carSideView.hidden = shouldHideCarSideView
        }
        
        defectMarkView.updateForNewSelectedSampleSide(SampleSide(rawValue: carSideSegmentedControl.selectedSegmentIndex)!)
    }
    
    private func updateChooseModelButton() {
        let buttonTitle = (selectedModelType != nil) ? selectedModelType!.name : "Choose Model"
        chooseModelButton.setTitle(buttonTitle, forState: UIControlState.Normal)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        guard let identifier = segue.identifier else { return }
        
        if identifier == "carModelPopover" {
            guard let destination = segue.destinationViewController as? CarModelTableViewController else { return }
            destination.delegate = self
        }
    }
}

extension CarSampleViewController: CarModelTableViewControllerDelegate {
    func carModelTableViewController(carModelTableViewController: CarModelTableViewController, didSelectModelType modelType: ModelType) {
        setSelectedModelType(modelType)
    }
}

extension CarSampleViewController: UIPickerViewDataSource {
    // MARK: UIPickerViewDataSource
    
    // The number of columns of data
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // The number of rows of data
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return defectTypes.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getTitleForRow(row, inPickerView: pickerView)
    }
    
    // The data to return for the row in the given picker view
    private func getTitleForRow(row: Int, inPickerView pickerView: UIPickerView) -> String? {
        return defectTypes[row].name
    }
}

extension CarSampleViewController: UIPickerViewDelegate {
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        //
        // hack to make font smaller
        //
        var defectLabel = view as? UILabel;
        if (defectLabel == nil)
        {
            defectLabel = UILabel()
            defectLabel!.font = UIFont.systemFontOfSize(14)
            defectLabel!.textAlignment = NSTextAlignment.Center
            
            defectLabel!.text = getTitleForRow(row, inPickerView: pickerView)
            defectLabel!.backgroundColor = defectTypes[row].getColor()
        }
        
        return defectLabel!;
    }
    
    private func centerWheelForDefectPickerView(pickerView: UIPickerView) {
        let numberOfRows = pickerView.numberOfRowsInComponent(0);
        let centerRow = Int(numberOfRows / 2)
        selectDefectRow(centerRow, forPickerView: pickerView)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        pickerDidSelectDefectRow(row)
    }
    
    private func selectDefectRow(row: Int, forPickerView pickerView: UIPickerView) {
        pickerView.selectRow(row, inComponent: 0, animated: false)
        pickerDidSelectDefectRow(row)
    }
    
    private func pickerDidSelectDefectRow(row: Int) {
        setSelectedDefectType(defectTypes[row])
    }
}