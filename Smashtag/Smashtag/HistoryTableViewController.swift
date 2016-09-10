//
//  HistoryTableViewController.swift
//  Smashtag
//
//  Created by Артем on 08/09/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class HistoryTableViewController: UITableViewController {

    // MARK: Model
    var historyRequests: [String] {
        return SearchStore.requests
    }
    
    private struct Storyboard {
        static let HistoryCell = "HistoryCell"
        static let FromHistorySegue = "ToTweetTVC"
    }
    
    // MARK: View Controller Lifecycle
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return historyRequests.count
    }

    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.HistoryCell, forIndexPath: indexPath)
        cell.textLabel?.text = historyRequests[indexPath.row]
        return cell
    }

    
//    // Override to support conditional editing of the table view.
//    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
//        // Return false if you do not want the specified item to be editable.
//        return true
//    }
    

    
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            SearchStore.removeAtIndex(indexPath.row)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        }
//        else if editingStyle == .Insert {
//            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
//        }    
    }
    

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if  segue.identifier == Storyboard.FromHistorySegue {
            if let tweetTVC = segue.destinationViewController as? TweetTableViewController,
            let cell = sender as? UITableViewCell {
                tweetTVC.searchText = cell.textLabel?.text
            }
        }
    }

}
