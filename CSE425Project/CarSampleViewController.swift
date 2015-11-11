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
    @IBOutlet weak var carLeftImageView: UIImageView!
    @IBOutlet weak var carTopImageView: UIImageView!
    @IBOutlet weak var carRightImageView: UIImageView!
    private var carSideImages = [UIImageView]()
    
    @IBOutlet weak var defectPickerView: UIPickerView!
    private var defectPickerData = ["Defect 1", "Defect 2", "Defect 3", "Defect 4", "Defect 5", "Defect 6", "Defect 7", "Defect 8", "Defect 9"]
    private let kDefectPickerTag = 7
    
    @IBOutlet weak var modelPickerView: UIPickerView!
    private var modelPickerData = ["Model 1", "Model 2", "Model 3", "Model 4", "Model 5", "Model 6", "Model 7", "Model 8", "Model 9"]
    private let kModelPickerTag = 8
    
    @IBAction func carSideSegmentedControlIndexDidChange(sender: AnyObject) {
        updateVisibleCarSide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carSideImages = [carLeftImageView, carTopImageView, carRightImageView]
        
        // initialize the visible car side image
        updateVisibleCarSide()
        
        // setup picker views
        defectPickerView.tag = kDefectPickerTag
        centerWheelForPickerView(defectPickerView)
        modelPickerView.tag = kModelPickerTag
        centerWheelForPickerView(modelPickerView)
    }
    
    // only show the car side that is currently selected; hide all the others
    private func updateVisibleCarSide() {
        for (index, carSideImage) in carSideImages.enumerate() {
            let shouldHideCarSideImage = (index != carSideSegmentedControl.selectedSegmentIndex)
            carSideImage.hidden = shouldHideCarSideImage
        }
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
        return (pickerView.tag == kDefectPickerTag) ? defectPickerData.count : modelPickerData.count
    }
    
    // The data to return for the row and component (column) that's being passed in
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return getTitleForRow(row, inPickerView: pickerView)
    }
    
    // The data to return for the row in the given picker view
    private func getTitleForRow(row: Int, inPickerView pickerView: UIPickerView) -> String? {
        return (pickerView.tag == kDefectPickerTag) ? defectPickerData[row] : modelPickerData[row]
    }
}

extension CarSampleViewController: UIPickerViewDelegate {
    // MARK: UIPickerViewDelegate
    
    func pickerView(pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusingView view: UIView?) -> UIView {
        //
        // hack to make font smaller
        //
        var pickerLabel = view as? UILabel;
        if (pickerLabel == nil)
        {
            pickerLabel = UILabel()
            pickerLabel?.font = UIFont.systemFontOfSize(14)
            pickerLabel?.textAlignment = NSTextAlignment.Center
        }
        
        pickerLabel?.text = getTitleForRow(row, inPickerView: pickerView)
        
        return pickerLabel!;
    }
    
    private func centerWheelForPickerView(pickerView: UIPickerView) {
        let numberOfRows = pickerView.numberOfRowsInComponent(0);
        let centerRow = Int(numberOfRows / 2)
        pickerView.selectRow(centerRow, inComponent: 0, animated: false)
    }
}