//
//  ImageTableViewCell.swift
//  Smashtag
//
//  Created by Артем on 07/09/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ImageTableViewCell: UITableViewCell {
    
    var imageUrl: NSURL? {
        didSet {
            updateUI()
        }
    }
    
    @IBOutlet weak var twitterImage: UIImageView!
    
    private func updateUI() {
        if let url = imageUrl {
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INITIATED, 0), {
                if let imageData = NSData(contentsOfURL: url) {
                    dispatch_async(dispatch_get_main_queue(), {
                        if url == self.imageUrl {
                        self.twitterImage.image = UIImage(data: imageData)
                        self.twitterImage.sizeToFit()
                        }
                    })
                }
            })
            
        }
    }
  

//    override func awakeFromNib() {
//        super.awakeFromNib()
//        // Initialization code
//    }
//
//    override func setSelected(selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

}
