//
//  CheckpointTableViewController.swift
//  CSE435Project
//
//  Created by adam on 11/12/15.
//  Copyright © 2015 Adam Schoonmaker. All rights reserved.
//

import UIKit

protocol CheckpointTableViewControllerDelegate: class {
    func checkpointTableViewController(checkpointTableViewController: CheckpointTableViewController, didSelectCheckpoint checkpoint: Checkpoint)
}

class CheckpointTableViewController: NewAnalysisTableViewController {
    
    weak var delegate: CheckpointTableViewControllerDelegate?
}

extension CheckpointTableViewController {
    // MARK: - Table view delegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        super.tableView(tableView, didSelectRowAtIndexPath: indexPath)
        
        var selectedCheckpoint: Checkpoint
        switch indexPath.row {
        case 1:
            selectedCheckpoint = .ECoat
        case 2:
            selectedCheckpoint = .Primer
        case 3:
            selectedCheckpoint = .TopCoat
        default:
            return
        }
        
        delegate?.checkpointTableViewController(self, didSelectCheckpoint: selectedCheckpoint)
    }
}