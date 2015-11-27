//
//  CarModelTableViewController.swift
//  CSE435Project
//
//  Created by adam on 11/11/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

protocol CarModelTableViewControllerDelegate: class {
    func carModelTableViewController(carModelTableViewController: CarModelTableViewController, didSelectModelType modelType: ModelType)
}

class CarModelTableViewController: UITableViewController {
    
    @IBInspectable var popoverSize: CGSize {
        get {
            return preferredContentSize
        }
        set {
            preferredContentSize = newValue
        }
    }
    
    weak var delegate: CarModelTableViewControllerDelegate?
    
    private var modelTypes = [ModelType]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        modelTypes = ModelType.fetchModelTypes()
    }
}

extension CarModelTableViewController {
    // MARK: - Table view data source
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return modelTypes.count
    }
}

extension CarModelTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let selectedModelType = modelTypes[indexPath.row]
        delegate?.carModelTableViewController(self, didSelectModelType: selectedModelType)
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("carModel", forIndexPath: indexPath)
        cell.textLabel?.text = modelTypes[indexPath.row].name
        return cell;
    }
    
    override func tableView(tableView: UITableView, willDisplayCell cell: UITableViewCell, forRowAtIndexPath indexPath: NSIndexPath) {
        cell.backgroundColor = UIColor.clearColor()
    }
}