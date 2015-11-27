//
//  ReportViewController.swift
//  CSE425Project
//
//  Created by adam on 11/26/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var carLeftView: UIView!
    @IBOutlet weak var carLeftImageView: UIImageView!
    let defectMarkViewLeft = DefectMarkView()
    
    @IBOutlet weak var carTopView: UIView!
    @IBOutlet weak var carTopImageView: UIImageView!
    let defectMarkViewTop = DefectMarkView()
    
    @IBOutlet weak var carRightView: UIView!
    @IBOutlet weak var carRightImageView: UIImageView!
    let defectMarkViewRight = DefectMarkView()
    
    // report summary labels
    @IBOutlet weak var defectsInReportLabel: UILabel!
    @IBOutlet weak var unitsInReportLabel: UILabel!
    @IBOutlet weak var defectsPerUnitLabel: UILabel!
    
    var analysis: Analysis!
    
    @IBAction func onBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSendButton(sender: AnyObject) {
        
    }
    
    @IBAction func onSave(sender: AnyObject) {
        let documentDirectory = NSSearchPathForDirectoriesInDomains(NSSearchPathDirectory.DocumentDirectory, NSSearchPathDomainMask.UserDomainMask, true)[0]
        let outputFilePath = "\(documentDirectory)/\(analysis.toFilenameString()).csv"
        print("saving to filepath:\(outputFilePath)")
        
        let csvString = analysis.toCsvString()
        
        do {
            try csvString.writeToFile(outputFilePath, atomically: true, encoding: NSUTF8StringEncoding)
        } catch {
            print("Couldn't save csv to disk")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // add the defect mark views for each side as subviews
        carLeftView.addSubview(defectMarkViewLeft)
        carTopView.addSubview(defectMarkViewTop)
        carRightView.addSubview(defectMarkViewRight)
        
        //
        // add the defects from all samples to their appropriate defect mark view
        //
        
        var leftSideDefects = [Defect]()
        var topSideDefects = [Defect]()
        var rightSideDefects = [Defect]()
        
        let samples = analysis.getSamplesArray()
        for sample in samples {
            for defect in sample.getDefectsArray() {
                switch defect.drawingSide {
                case .Left:
                    leftSideDefects.append(defect)
                case .Top:
                    topSideDefects.append(defect)
                case .Right:
                    rightSideDefects.append(defect)
                }
            }
        }
        
        defectMarkViewLeft.updateWithDefects(leftSideDefects)
        defectMarkViewTop.updateWithDefects(topSideDefects)
        defectMarkViewRight.updateWithDefects(rightSideDefects)
        
        // 
        // get data for report summary labels and set them
        //
        
        let numberOfDefects = leftSideDefects.count + topSideDefects.count + rightSideDefects.count
        let numberOfUnits = samples.count
        let defectsPerUnit = Float(numberOfDefects) / Float(numberOfUnits)
        
        defectsInReportLabel.text = "Defects in Report: \(numberOfDefects)"
        unitsInReportLabel.text = "Units in Report: \(numberOfUnits)"
        defectsPerUnitLabel.text = "Defects Per Unit: \(defectsPerUnit)"
    }
    
    override func viewDidLayoutSubviews() {
        defectMarkViewLeft.frame = frameForImage(carLeftImageView.image!, inAspectFitImageView: carLeftImageView)
        defectMarkViewTop.frame = frameForImage(carTopImageView.image!, inAspectFitImageView: carTopImageView)
        defectMarkViewRight.frame = frameForImage(carRightImageView.image!, inAspectFitImageView: carRightImageView)
    }
}
