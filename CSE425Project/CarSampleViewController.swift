//
//  CarSampleViewController.swift
//  CSE425Project
//
//  Created by adam on 11/11/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class CarSampleViewController: UIViewController {

    @IBOutlet weak var carSideSegmentedControl: UISegmentedControl!
    @IBOutlet weak var carLeftSideView: UIView!
    @IBOutlet weak var carTopSideView: UIView!
    @IBOutlet weak var carRightSideView: UIView!
    @IBOutlet weak var defectMarkView: DefectMarkView!
    private var carSideViews = [UIView]()
    
    @IBOutlet weak var defectPickerView: UIPickerView!
    private var defectTypes = [DefectType]()
    
    private(set) var selectedDefectType: DefectType!
    
    private func setSelectedDefectType(defectType: DefectType) {
        selectedDefectType = defectType
        defectMarkView.setCurrentlySelectedDefectType(defectType)
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
    }
    
    
    // only show the car side that is currently selected; hide all the others
    private func updateVisibleCarSide() {
        for (index, carSideView) in carSideViews.enumerate() {
            let shouldHideCarSideView = (index != carSideSegmentedControl.selectedSegmentIndex)
            carSideView.hidden = shouldHideCarSideView
        }
        
        defectMarkView.updateForNewSide()
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