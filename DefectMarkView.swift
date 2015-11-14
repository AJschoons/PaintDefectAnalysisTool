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
        guard let mark = mark else {return}
        
        if touchableRect.contains(mark) {
            self.mark = mark
            setNeedsDisplay()
        }
    }
    
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
    
    func updateForNewSide() {
        mark = nil
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
        
        guard let mark = mark else {
            return
        }
        
        // Drawing code
        
        strokeCircleWithCenter(mark, andColor: currentlySelectedDefectType.getColor())
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
