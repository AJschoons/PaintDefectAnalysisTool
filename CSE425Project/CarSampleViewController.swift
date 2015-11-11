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
    
    @IBAction func carSideSegmentedControlIndexDidChange(sender: AnyObject) {
        updateVisibleCarSide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        carSideImages = [carLeftImageView, carTopImageView, carRightImageView]
        
        // initialize the visible car side image
        updateVisibleCarSide()
    }
    
    // only show the car side that is currently selected; hide all the others
    private func updateVisibleCarSide() {
        for (index, carSideImage) in carSideImages.enumerate() {
            let shouldHideCarSideImage = (index != carSideSegmentedControl.selectedSegmentIndex)
            carSideImage.hidden = shouldHideCarSideImage
        }
    }
}
