//
//  ReportViewController.swift
//  CSE435Project
//
//  Created by adam on 11/26/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var spacerButton: UIBarButtonItem!
    
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
        let url = NSURL(string: "https://www.cse.msu.edu/~cse435/Projects/F2015/Groups/Team6/receive_data/receiveData.php")
        let request = NSMutableURLRequest(URL: url!, cachePolicy: NSURLRequestCachePolicy.UseProtocolCachePolicy, timeoutInterval: 60)
        request.HTTPMethod = "POST"
        request.HTTPBody = "data=\(analysis.toCsvString())".dataUsingEncoding(NSUTF8StringEncoding)
        let connection = NSURLConnection(request: request, delegate: nil)
        connection!.start()
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
        
        saveButton.enabled = false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let barButtonBackgroundHidden = UIImage(named: "barButtonBackgroundHidden")
        spacerButton.setBackgroundImage(barButtonBackgroundHidden, forState: UIControlState.Disabled, barMetrics: UIBarMetrics.Default)
        spacerButton.enabled = false
        
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
