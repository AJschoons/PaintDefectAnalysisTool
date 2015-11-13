//
//  ShiftTableViewController.swift
//  CSE425Project
//
//  Created by adam on 11/12/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

protocol ShiftTableViewControllerDelegate {
    func shiftTableViewController(shiftTableViewController: ShiftTableViewController, didSelectShift shift: Shift)
}

class ShiftTableViewController: NewAnalysisTableViewController {
    
    var delegate: ShiftTableViewControllerDelegate?
}

extension ShiftTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        var selectedShift: Shift
        switch indexPath.row {
        case 1:
            selectedShift = .Morning
        case 2:
            selectedShift = .Afternoon
        case 3:
            selectedShift = .Evening
        default:
            return
        }
        
        delegate?.shiftTableViewController(self, didSelectShift: selectedShift)
    }
}