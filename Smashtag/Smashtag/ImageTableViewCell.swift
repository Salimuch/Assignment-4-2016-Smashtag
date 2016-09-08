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
            if let imageData = NSData(contentsOfURL: url) {
                twitterImage.image = UIImage(data: imageData)
                twitterImage.sizeToFit()
            }
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
