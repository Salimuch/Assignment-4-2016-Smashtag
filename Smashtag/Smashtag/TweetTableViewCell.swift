//
//  TweetTableViewCell.swift
//  Smashtag
//
//  Created by CS193p Instructor.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit
import Twitter

class TweetTableViewCell: UITableViewCell
{
    @IBOutlet weak var tweetScreenNameLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var tweetProfileImageView: UIImageView!
    @IBOutlet weak var tweetCreatedLabel: UILabel!
    
    var tweet: Twitter.Tweet? {
        didSet {
            updateUI()
        }
    }
    
    private struct MentionsColor {
        static let Hashtag = UIColor.redColor()
        static let Url = UIColor.greenColor()
        static let UserMention = UIColor.blueColor()
    }
    
    private func attributionTweetText (tweet: Twitter.Tweet) -> NSMutableAttributedString {
        let attributedString = NSMutableAttributedString(string: tweet.text)
        setCollorAttributes(toAttributedString: attributedString, forMentions: tweet.hashtags, setColor: MentionsColor.Hashtag)
        setCollorAttributes(toAttributedString: attributedString, forMentions: tweet.urls, setColor: MentionsColor.Url)
        setCollorAttributes(toAttributedString: attributedString, forMentions: tweet.userMentions, setColor: MentionsColor.UserMention)
        return attributedString
    }
    
    private func setCollorAttributes(toAttributedString attributedString: NSMutableAttributedString, forMentions mentions: [Twitter.Mention], setColor color: UIColor) {
        for mention in mentions {
            attributedString.addAttribute(NSForegroundColorAttributeName, value: color, range: mention.nsrange)
        }
    }
    
    private func updateUI()
    {
        // reset any existing tweet information
        tweetTextLabel?.attributedText = nil
        tweetScreenNameLabel?.text = nil
        tweetProfileImageView?.image = nil
        tweetCreatedLabel?.text = nil
        
        // load new information from our tweet (if any)
        if let tweet = self.tweet
        {
            tweetTextLabel?.attributedText = attributionTweetText(tweet)
            
            if tweetTextLabel?.text != nil  {
                for _ in tweet.media {
                    tweetTextLabel.text! += " 📷"
                }
            }
            
            tweetScreenNameLabel?.text = "\(tweet.user)" // tweet.user.description
            
            if let profileImageURL = tweet.user.profileImageURL {
                dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0)) {
                    if let imageData = NSData(contentsOfURL: profileImageURL) { // blocks main thread!
                        dispatch_async(dispatch_get_main_queue()) {
                            if profileImageURL == tweet.user.profileImageURL {
                                self.tweetProfileImageView?.image = UIImage(data: imageData)
                            }
                        }
                    }
                }
            }
            
            let formatter = NSDateFormatter()
            if NSDate().timeIntervalSinceDate(tweet.created) > 24*60*60 {
                formatter.dateStyle = NSDateFormatterStyle.ShortStyle
            } else {
                formatter.timeStyle = NSDateFormatterStyle.ShortStyle
            }
            tweetCreatedLabel?.text = formatter.stringFromDate(tweet.created)
        }

    }
    
}
