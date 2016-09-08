//
//  MentionsTableViewController.swift
//  Smashtag
//
//  Created by Артем on 07/09/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class MentionsTableViewController: UITableViewController {
    
    // MARK: - Internal Mentions Model
    private var mentions: [MentionsStruct] = []
    
    private enum MentionType {
        case image(NSURL, Double)
        case keyWord(String)
    }
    
    private struct MentionsStruct {
        var type: String
        var mentions: [MentionType]
        var description: String {
            return ("\(type)")
        }
        
    }
    
    private func setMentions() {
        if let imageMention = tweet?.media where imageMention.count > 0{
                mentions.append(MentionsStruct(type: "image",
                    mentions: imageMention.map { MentionType.image($0.url, $0.aspectRatio) }))
        }
        if let urlMention = tweet?.urls where urlMention.count > 0 {
                mentions.append(MentionsStruct(type: "url",
                    mentions: urlMention.map { MentionType.keyWord($0.keyword) }))
        }
        if let hashtagMention = tweet?.hashtags where hashtagMention.count > 0 {
                mentions.append(MentionsStruct(type: "hashtag",
                    mentions: hashtagMention.map { MentionType.keyWord($0.keyword) }))
        }
        if let userMention = tweet?.userMentions where userMention.count > 0 {
                mentions.append(MentionsStruct(type: "userMention",
                    mentions: userMention.map { MentionType.keyWord($0.keyword)} ))
        }
    }
    
    // MARK: - Model
    var tweet: Twitter.Tweet? {
        didSet {
            setMentions()
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }

    // MARK: - Table view data source
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return mentions.count
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return mentions[section].mentions.count
    }

    override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return mentions[section].description
    }
    
    override func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let mention = mentions[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .image(_, let ratio):
            return tableView.bounds.size.width / CGFloat(ratio)
        default: return UITableViewAutomaticDimension
        }
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let mention = mentions[indexPath.section].mentions[indexPath.row]
        
        switch mention {
        case .image(let imageUrl, _):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.ImageCell, forIndexPath: indexPath)
            if let imageCell = cell as? ImageTableViewCell {
                imageCell.imageUrl = imageUrl
            }
            return cell
        case .keyWord(let keyword):
            let cell = tableView.dequeueReusableCellWithIdentifier(Storyboard.OtherMentionCell, forIndexPath: indexPath)
            cell.textLabel?.text = keyword
            return cell
        }
    }
    
    private struct Storyboard {
        static let ImageCell = "ImageMention"
        static let OtherMentionCell = "OtherMention"
        
        static let OtherMentionSegue = "FromMention"
        static let ImageMentionSegue = "FromImage"
    }

    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if let identifier = segue.identifier {
            switch identifier {
            case Storyboard.OtherMentionSegue:
                if let cell = sender as? UITableViewCell,
                    let tweetTVC = segue.destinationViewController as? TweetTableViewController {
                    tweetTVC.searchText = cell.textLabel?.text
                }
            case Storyboard.ImageMentionSegue:
                if let cell = sender as? ImageTableViewCell,
                    let imageVC = segue.destinationViewController as? ImageViewController {
                    imageVC.imageURL = cell.imageUrl
                }
            default: break
            }
        }
    }
    
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject?) -> Bool {
        if identifier == Storyboard.OtherMentionSegue,
            let cell = sender as? UITableViewCell
        {
            let indexPath = tableView.indexPathForCell(cell)
            if mentions[indexPath!.section].description == "url" {
                UIApplication.sharedApplication().openURL(NSURL(string: (cell.textLabel?.text)!)!)
                return false
            }
        }
        return true
    }

}
