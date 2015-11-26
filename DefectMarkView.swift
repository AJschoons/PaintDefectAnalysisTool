//
//  DefectMarkView.swift
//  CSE425Project
//
//  Created by adam on 11/13/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class DefectMarkView: UIView {
    
    private let margin: CGFloat = 20
    private let defectRadius: CGFloat = 10
    
    // the previously marked defects to be drawn for the current side
    private var defects = [Defect]()
    
    // the mark for the defect currently being created
    private(set) var mark: CGPoint?
    private func setMark(mark: CGPoint?) {
        if mark == nil || touchableRect.contains(mark!) {
            self.mark = mark
            updateMarkVariablesFromNewMark(mark)
            updateLabelTextFromMarkVariables()
            setNeedsDisplay()
        }
    }
    
    private(set) var markRegion: DefectRegion?
    private(set) var markPlane: DefectPlane?
    private(set) var markSide: DefectSide?
    
    private(set) var selectedSampleSide: SampleSide!
    
    // used to display information about the defect
    private var defectLocationInformationLabel: UILabel!
    
    private let roofBezierPath = UIBezierPath()
    private let roofBeizerColor = UIColor.greenColor().colorWithAlphaComponent(0.1)
    private let hoodBezierPath = UIBezierPath()
    private let hoodBeizerColor = UIColor.blueColor().colorWithAlphaComponent(0.1)
    private let deckBezierPath = UIBezierPath()
    private let deckBeizerColor = UIColor.redColor().colorWithAlphaComponent(0.15)
    private let leftSideBezierPath = UIBezierPath()
    private let rightSideBezierPath = UIBezierPath()
    
    private var currentlySelectedDefectType: DefectType!
    
    func setCurrentlySelectedDefectType(defectType: DefectType) {
        currentlySelectedDefectType = defectType
        setNeedsDisplay()
    }
    
    private var touchableRect: CGRect! // The region we allow the defects to be placed
    
    // MARK: Initialization
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        initialize()
    }
    
    private func initialize() {
        multipleTouchEnabled = false
        backgroundColor = UIColor.clearColor()
        
        // Setup the label
        defectLocationInformationLabel = UILabel()
        defectLocationInformationLabel.textColor = UIColor.whiteColor()
        defectLocationInformationLabel.font = UIFont.systemFontOfSize(18)
        defectLocationInformationLabel.textAlignment = .Right
        defectLocationInformationLabel.text = "Some test text"
        addSubview(defectLocationInformationLabel)
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    // MARK: Functions
    
    func updateForNewSelectedSampleSide(sampleSide: SampleSide, defectsForSampleSide defects: [Defect]) {
        selectedSampleSide = sampleSide
        updateWithDefects(defects)
        setMark(nil) // calls redraw
    }
    
    func updateWithDefects(defects: [Defect]) {
        self.defects = defects
        setNeedsDisplay()
    }
    
    func resetAfterMarkingDefect() {
        setMark(nil)
    }
    
    private func updateMarkVariablesFromNewMark(mark: CGPoint?) {
        guard let mark = mark else {
            markPlane = nil
            markRegion = nil
            markSide = nil
            return
        }
        
        if (selectedSampleSide == .Left) {
            markPlane = .Vertical
            markRegion = .LeftVertical
            markSide = .Left
        } else if (selectedSampleSide == .Right) {
            markPlane = .Vertical
            markRegion = .RightVertical
            markSide = .Right
        } else {
            // Top side of sample is currently selected
            markPlane = .Horizontal
            
            // Decide which region the mark is in
            if (roofBezierPath.containsPoint(mark)) {
                markRegion = .Roof
            } else if (hoodBezierPath.containsPoint(mark)) {
                markRegion = .Hood
            } else if (deckBezierPath.containsPoint(mark)) {
                markRegion = .Deck
            } else {
                markRegion = nil
            }
            
            // Decide which half the mark is on
            if (leftSideBezierPath.containsPoint(mark)) {
                markSide = .Left
            } else if (rightSideBezierPath.containsPoint(mark)) {
                markSide = .Right
            } else {
                markSide = nil
            }
        }
    }
    
    private func updateLabelTextFromMarkVariables() {
        guard let _ = mark else {
            defectLocationInformationLabel.text = ""
            return
        }
        
        let regionText = (markRegion != nil) ? markRegion!.toString() : "N/A"
        let sideText = (markSide != nil) ? markSide!.toString() : "N/A"
        
        if selectedSampleSide == .Top {
            defectLocationInformationLabel.text = "Region: \(regionText), Side: \(sideText)"
        } else {
            // .Left or .Right, so side is implied and need not be displayed
            defectLocationInformationLabel.text = "Region: \(regionText)"
        }
    }
    
    // MARK: Drawing
    
    override func layoutSubviews() {
        // Layout the label
        let labelX = frame.origin.x + margin
        let labelY = frame.origin.y + margin
        let labelWidth = frame.width - margin * 2
        let labelHeight: CGFloat = 20
        defectLocationInformationLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
    }
    
    override func drawRect(rect: CGRect) {
        touchableRect = CGRect(x: margin, y: margin, width: rect.width - margin*2, height: rect.height - margin*2)
        
        //
        // Drawing code
        //
        
        // if looking at top, draw the defect regions we classified
        if (selectedSampleSide == .Top) {
            strokeTopRegionsInRect(rect)
        }
        
        // draw the previous placed defects for this side
        for defect in defects {
            let defectScaledLocation = defect.getScaledLocation()
            let defectX = CGFloat(defectScaledLocation.x * Double(rect.width))
            let defectY = CGFloat(defectScaledLocation.y * Double(rect.height))
            strokeCircleWithCenter(CGPoint(x: defectX, y: defectY), radius: defectRadius, color: defect.type.getColor())
        }
        
        // draw the defect mark currently being placed
        if mark != nil {
            strokeCircleWithCenter(mark!, radius: defectRadius + 3, color: UIColor.whiteColor())
            strokeCircleWithCenter(mark!, radius: defectRadius, color: currentlySelectedDefectType.getColor())
        }
    }
    
    private func strokeTopRegionsInRect(rect: CGRect) {
        let w = rect.width
        let h = rect.height
        
        //
        // roof region
        //
        
        let roofTopLeft = CGPoint(x: w * 0.14783, y: h * 0.29)
        let roofBottomLeft = CGPoint(x: w * 0.14783, y: h * 0.7)
        let roofTopMiddle = CGPoint(x: w * 0.50435, y: h * 0.29)
        let roofBottomMiddle = CGPoint(x: w * 0.50435, y: h * 0.7)
        let roofTopRight = CGPoint(x: w * 0.65217, y: h * 0.22)
        let roofBottomRight = CGPoint(x: w * 0.65217, y: h * 0.78)
        
        roofBeizerColor.set()
        roofBezierPath.moveToPoint(roofTopLeft)
        roofBezierPath.addLineToPoint(roofBottomLeft)
        roofBezierPath.addLineToPoint(roofBottomMiddle)
        roofBezierPath.addLineToPoint(roofBottomRight)
        roofBezierPath.addLineToPoint(roofTopRight)
        roofBezierPath.addLineToPoint(roofTopMiddle)
        roofBezierPath.closePath()
        roofBezierPath.fill()
        
        //
        // hood region
        //
        
        let hoodTopRight = CGPoint(x: w * 0.90435, y: h * 0.25)
        let hoodBottomRight = CGPoint(x: w * 0.90435, y: h * 0.75)
        
        hoodBeizerColor.set()
        hoodBezierPath.moveToPoint(roofTopRight)
        hoodBezierPath.addLineToPoint(roofBottomRight)
        hoodBezierPath.addLineToPoint(hoodBottomRight)
        hoodBezierPath.addLineToPoint(hoodTopRight)
        hoodBezierPath.closePath()
        hoodBezierPath.fill()
        
        //
        // deck region
        //
        
        let deckTopLeft = CGPoint(x: w * 0.05652, y: h * 0.19)
        let deckBottomLeft = CGPoint(x: w * 0.05652, y: h * 0.8)
        
        deckBeizerColor.set()
        deckBezierPath.moveToPoint(roofTopLeft)
        deckBezierPath.addLineToPoint(deckTopLeft)
        deckBezierPath.addLineToPoint(deckBottomLeft)
        deckBezierPath.addLineToPoint(roofBottomLeft)
        deckBezierPath.closePath()
        deckBezierPath.fill()
        
        //
        // right region
        //
        
        let carMiddleLeft = CGPoint(x: deckTopLeft.x, y: (deckTopLeft.y + deckBottomLeft.y) / 2)
        let carMiddleRight = CGPoint(x: hoodTopRight.x, y: (hoodTopRight.y + hoodBottomRight.y) / 2)
        
        rightSideBezierPath.moveToPoint(carMiddleLeft)
        rightSideBezierPath.addLineToPoint(deckBottomLeft)
        rightSideBezierPath.addLineToPoint(roofBottomLeft)
        rightSideBezierPath.addLineToPoint(roofBottomMiddle)
        rightSideBezierPath.addLineToPoint(roofBottomRight)
        rightSideBezierPath.addLineToPoint(hoodBottomRight)
        rightSideBezierPath.addLineToPoint(carMiddleRight)
        rightSideBezierPath.closePath()
        
        //
        // left region
        //

        leftSideBezierPath.moveToPoint(deckTopLeft)
        leftSideBezierPath.addLineToPoint(carMiddleLeft)
        leftSideBezierPath.addLineToPoint(carMiddleRight)
        leftSideBezierPath.addLineToPoint(hoodTopRight)
        leftSideBezierPath.addLineToPoint(roofTopRight)
        leftSideBezierPath.addLineToPoint(roofTopMiddle)
        leftSideBezierPath.addLineToPoint(roofTopLeft)
        leftSideBezierPath.closePath()
    }
    
    private func strokeCircleWithCenter(center: CGPoint, radius: CGFloat, color: UIColor) {
        let bp = UIBezierPath()
        bp.addArcWithCenter(center, radius: radius, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: false)
        color.set()
        bp.fill()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setMark(touches.first?.locationInView(self))
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setMark(touches.first?.locationInView(self))
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        setMark(touches.first?.locationInView(self))
    }
}
