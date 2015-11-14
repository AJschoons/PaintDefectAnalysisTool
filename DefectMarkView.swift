//
//  DefectMarkView.swift
//  CSE425Project
//
//  Created by adam on 11/13/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

class DefectMarkView: UIView {
    
    var mark: CGPoint?
    
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
        // Drawing code
        guard let mark = mark else {
            return
        }
        
        let color = UIColor.redColor()
        strokeCircleWithCenter(mark, andColor: color)
    }
    
    private func strokeCircleWithCenter(center: CGPoint, andColor color: UIColor) {
        let bp = UIBezierPath()
        bp.addArcWithCenter(center, radius: 10, startAngle: 0, endAngle: CGFloat(2.0*M_PI), clockwise: false)
        color.set()
        bp.fill()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        mark = touches.first?.locationInView(self)
        setNeedsDisplay()
    }
    
    override func touchesMoved(touches: Set<UITouch>, withEvent event: UIEvent?) {
        mark = touches.first?.locationInView(self)
        setNeedsDisplay()
    }
    
    override func touchesEnded(touches: Set<UITouch>, withEvent event: UIEvent?) {
        mark = touches.first?.locationInView(self)
        setNeedsDisplay()
    }
}
