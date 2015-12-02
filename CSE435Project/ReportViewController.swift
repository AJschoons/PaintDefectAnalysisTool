//
//  ReportViewController.swift
//  CSE435Project
//
//  Created by adam on 11/26/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class ReportViewController: UIViewController {

    @IBOutlet weak var sendingOverlay: UIView!
    @IBOutlet weak var sendingPopup: UIView!
    
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    @IBOutlet weak var spacerButton: UIBarButtonItem!
    @IBOutlet weak var sendButton: UIBarButtonItem!
    
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
    
    private var overlayHasBeenVisibleForMinimumAmountOfTime = false
    private var csvDataUploadAttemptHasCompleted = false
    
    @IBAction func onBackButton(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onSendButton(sender: AnyObject) {
        uploadCsvData()
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
    
    private func uploadCsvData() {
        let config = NSURLSessionConfiguration.ephemeralSessionConfiguration()
        let session = NSURLSession(configuration: config)
        
        let url = NSURL(string: "https://www.cse.msu.edu/~cse435/Projects/F2015/Groups/Team6/receive_data/receiveData.php")
        let request = NSMutableURLRequest(URL: url!)
        request.HTTPMethod = "POST"
        let csvData = "data=\(analysis.toCsvString())".dataUsingEncoding(NSUTF8StringEncoding)
        
        onCsvUploadTaskAttempt()
        
        let uploadTask = session.uploadTaskWithRequest(request, fromData: csvData) { [weak self] data, response, error in
            guard let strongSelf = self else { return }
            dispatch_async(dispatch_get_main_queue(), {
                strongSelf.onCsvUploadTaskAttemptCompletion(data, response: response, error: error)
            })
        }
        
        uploadTask.resume()
    }
    
    // actions to perform before attempting to upload csv
    private func onCsvUploadTaskAttempt() {
        animateSendingOverlayToBeShown(true)
        sendButton.enabled = false
        csvDataUploadAttemptHasCompleted = false
    }
    
    // actions to perform after attempting to upload csv
    private func onCsvUploadTaskAttemptCompletion(data: NSData?, response: NSURLResponse?, error: NSError?) {
        csvDataUploadAttemptHasCompleted = true
        
        let errorString = "Error posting CSV data to server"
        
        guard let response = response as? NSHTTPURLResponse where error == nil else {
            print(errorString)
            sendButton.enabled = true
            hideSendingOverlay()
            showFailedSendingAlert()
            return
        }
        
        guard response.statusCode == 200 else {
            print(errorString + ": HTTP status code not success")
            sendButton.enabled = true
            hideSendingOverlay()
            showFailedSendingAlert()
            return
        }
        
        print("success posting data")
        animateSendingOverlayToBeShown(false)
        sendButton.enabled = false
    }
    
    private func showFailedSendingAlert() {
        let alertTitle = "Unable To Upload"
        let alertDismissAction = UIAlertAction(title: "Okay", style: .Default, handler: nil)
        let alertMessage = "Please try sending again"
        let alertController = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .Alert)
        alertController.addAction(alertDismissAction)
        presentViewController(alertController, animated: true, completion: nil)
    }
    
    private func animateSendingOverlayToBeShown(toBeShown: Bool) {
        let animationDuration = 0.3
        let minimumOverlayShowTime = 2.0
        
        if toBeShown {
            overlayHasBeenVisibleForMinimumAmountOfTime = false
            UIView.animateWithDuration(animationDuration) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.showSendingOverlay()
                NSTimer.scheduledTimerWithTimeInterval(minimumOverlayShowTime, target: strongSelf, selector: "minimumOverlayVisibilityTimerHasCompleted", userInfo: nil, repeats: false)
            }
        } else if overlayHasBeenVisibleForMinimumAmountOfTime && csvDataUploadAttemptHasCompleted {
            UIView.animateWithDuration(animationDuration) { [weak self] in
                guard let strongSelf = self else { return }
                strongSelf.hideSendingOverlay()
            }
        }
    }
    
    func minimumOverlayVisibilityTimerHasCompleted() {
        overlayHasBeenVisibleForMinimumAmountOfTime = true
        animateSendingOverlayToBeShown(false)
    }
    
    private func showSendingOverlay() {
        sendingOverlay.alpha = 0.5
        sendingPopup.alpha = 1
    }
    
    private func hideSendingOverlay() {
        sendingOverlay.alpha = 0
        sendingPopup.alpha = 0
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideSendingOverlay()
        
        let barButtonBackgroundHidden = UIImage(named: "barButtonBackgroundHidden")
        spacerButton.setBackgroundImage(barButtonBackgroundHidden, forState: UIControlState.Disabled, barMetrics: UIBarMetrics.Default)
        spacerButton.enabled = false
        
        let dataFromDefectMarkViewInitialization = initializeDefectMarkViews()
        initializeReportSummaryLabels(dataFromDefectMarkViewInitialization)
    }
    
    private func initializeDefectMarkViews() -> (numberOfDefects: Int, numberOfUnits: Int) {
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
        
        let numberOfDefects = leftSideDefects.count + topSideDefects.count + rightSideDefects.count
        let numberOfUnits = samples.count
        
        return (numberOfDefects, numberOfUnits)
    }
    
    private func initializeReportSummaryLabels(defectData: (numberOfDefects: Int, numberOfUnits: Int)) {
        let defectsPerUnit = Float(defectData.numberOfDefects) / Float(defectData.numberOfUnits)
        
        defectsInReportLabel.text = "Defects in Report: \(defectData.numberOfDefects)"
        unitsInReportLabel.text = "Units in Report: \(defectData.numberOfUnits)"
        defectsPerUnitLabel.text = "Defects Per Unit: \(defectsPerUnit)"
    }
    
    override func viewDidLayoutSubviews() {
        defectMarkViewLeft.frame = frameForImage(carLeftImageView.image!, inAspectFitImageView: carLeftImageView)
        defectMarkViewTop.frame = frameForImage(carTopImageView.image!, inAspectFitImageView: carTopImageView)
        defectMarkViewRight.frame = frameForImage(carRightImageView.image!, inAspectFitImageView: carRightImageView)
    }
}
