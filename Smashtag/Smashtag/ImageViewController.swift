//
//  ImageViewController.swift
//  Smashtag
//
//  Created by Артем on 08/09/16.
//  Copyright © 2016 Stanford University. All rights reserved.
//

import UIKit

class ImageViewController: UIViewController, UIScrollViewDelegate {
    
    // MARK - Model
    var imageURL: NSURL? {
        didSet {
            image = nil
            if view.window != nil {
                fetchImage()
            }
        }
    }
    
    private var isAutozooming = true
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    
    @IBOutlet weak var scrollView: UIScrollView! {
        didSet {
            scrollView.contentSize = imageView.frame.size
            scrollView.delegate = self
            scrollView.minimumZoomScale = 0.03
            scrollView.maximumZoomScale = 1.0
        }
    }
    
    @IBAction func toRootViewController(sender: UIBarButtonItem) {
        navigationController?.popToRootViewControllerAnimated(true)
    }
    
    private var imageView = UIImageView()

    private var image: UIImage? {
        get {
            return imageView.image
        }
        set {
            imageView.image = newValue
            imageView.sizeToFit()
            scrollView?.contentSize = imageView.frame.size
            spinner?.stopAnimating()
            isAutozooming = true
            autozooming()
        }
    }
    
    private func autozooming() {
        if isAutozooming {
            if imageView.bounds.size.width > 0 && imageView.bounds.size.height > 0 {
                let widthRatio = scrollView.bounds.size.width / imageView.bounds.size.width
                let heightRatio = scrollView.bounds.size.height / imageView.bounds.size.height
                scrollView.zoomScale = max(widthRatio,heightRatio)
                scrollView.contentOffset = CGPoint(x: (imageView.frame.size.width - scrollView.frame.size.width) / 2,
                                                   y: (imageView.frame.size.height - scrollView.frame.size.height) / 2)
            }
        }
    }
    
    private func fetchImage() {
        if let url = imageURL {
            spinner?.startAnimating()
            dispatch_async(dispatch_get_global_queue(QOS_CLASS_USER_INTERACTIVE, 0)) {
                let contentsOfURL = NSData(contentsOfURL: url)
                dispatch_async(dispatch_get_main_queue()) {
                    if url == self.imageURL {
                        if let imageData = contentsOfURL {
                            self.image = UIImage(data: imageData)
                        } else { self.spinner?.stopAnimating() }
                    } else {
                        print ("Ignored data returned url \(url)")
                    }
                    
                }
            }
        }
    }
    
    // MARK: Scroll View Delegate
    func viewForZoomingInScrollView(scrollView: UIScrollView) -> UIView? {
        return imageView
    }
    
    func scrollViewWillBeginZooming(scrollView: UIScrollView, withView view: UIView?) {
        isAutozooming = false
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        scrollView.addSubview(imageView)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if image == nil {
            fetchImage()
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autozooming()
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
