//
//  FactoryTableViewController.swift
//  CSE425Project
//
//  Created by adam on 11/12/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

protocol FactoryTableViewControllerDelegate {
    func factoryTableViewController(factoryTableViewController: FactoryTableViewController, didSelectFactory factory: Factory)
}

class FactoryTableViewController: NewAnalysisTableViewController {

    var delegate: FactoryTableViewControllerDelegate?
}

extension FactoryTableViewController {
    // MARK: - Table view data source
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1 + Factory.fetchFactories().count
    }
}

extension FactoryTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        let selectedFactory = Factory.fetchFactories()[indexPath.row - 1]
        delegate?.factoryTableViewController(self, didSelectFactory: selectedFactory)
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: UITableViewCell!
        
        if indexPath.row == 0 {
            cell = tableView.dequeueReusableCellWithIdentifier("factoryHeaderCell", forIndexPath: indexPath)
        } else {
            cell = tableView.dequeueReusableCellWithIdentifier("factoryCell", forIndexPath: indexPath)
            cell.textLabel?.text = Factory.fetchFactories()[indexPath.row - 1].name
        }
        
        return cell;
    }
}