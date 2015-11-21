//
//  DefectMarkView.swift
//  CSE425Project
//
//  Created by adam on 11/13/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class DefectMarkView: UIView {
    
    private var mark: CGPoint?
    private func setMark(mark: CGPoint?) {
        guard let mark = mark else { return }
        
        if touchableRect.contains(mark) {
            self.mark = mark
            setNeedsDisplay()
        }
    }
    
    private var selectedSampleSide: SampleSide!
    
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
    
    private var touchableRect: CGRect! // The region we allow the defect to be placed
    
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
    }
    
    func updateForNewSelectedSampleSide(sampleSide: SampleSide) {
        mark = nil
        selectedSampleSide = sampleSide
        setNeedsDisplay()
    }
    
    override func canBecomeFirstResponder() -> Bool {
        return true
    }
    
    override func drawRect(rect: CGRect) {
        if touchableRect == nil {
            let margin: CGFloat = 20
            touchableRect = CGRect(x: margin, y: margin, width: rect.width - margin*2, height: rect.height - margin*2)
        }
        
        //
        // Drawing code
        //
        
        if (selectedSampleSide == .Top) {
            strokeTopRegionsInRect(rect)
        }
        
        if mark != nil {
            strokeCircleWithCenter(mark!, andColor: currentlySelectedDefectType.getColor())
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
        // left region
        //
        
        let carMiddleLeft = CGPoint(x: deckTopLeft.x, y: (deckTopLeft.y + deckBottomLeft.y) / 2)
        let carMiddleRight = CGPoint(x: hoodTopRight.x, y: (hoodTopRight.y + hoodBottomRight.y) / 2)
        
        leftSideBezierPath.moveToPoint(carMiddleLeft)
        leftSideBezierPath.addLineToPoint(deckBottomLeft)
        leftSideBezierPath.addLineToPoint(roofBottomLeft)
        leftSideBezierPath.addLineToPoint(roofBottomMiddle)
        leftSideBezierPath.addLineToPoint(roofBottomRight)
        leftSideBezierPath.addLineToPoint(hoodBottomRight)
        leftSideBezierPath.addLineToPoint(carMiddleRight)
        leftSideBezierPath.closePath()
        
        //
        // right region
        //
        
        rightSideBezierPath.moveToPoint(deckTopLeft)
        rightSideBezierPath.addLineToPoint(carMiddleLeft)
        rightSideBezierPath.addLineToPoint(carMiddleRight)
        rightSideBezierPath.addLineToPoint(hoodTopRight)
        rightSideBezierPath.addLineToPoint(roofTopRight)
        rightSideBezierPath.addLineToPoint(roofTopMiddle)
        rightSideBezierPath.addLineToPoint(roofTopLeft)
        rightSideBezierPath.closePath()
    }
    
    private func strokeCircleWithCenter(center: CGPoint, andColor color: UIColor) {
        let bp = UIBezierPath()
        bp.addArcWithCenter(center, radius: 10, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: false)
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
