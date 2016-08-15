//
//  DetailsVC.swift
//  MovieApp2
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit
import WebKit

class DetailsVC: UIViewController {
    
    @IBOutlet weak var detailsImg: UIImageView!
    @IBOutlet weak var detailsTitle: UILabel!
    @IBOutlet weak var detailsDescription: UILabel!
 //   @IBOutlet weak var containerSummary: UIView!
//    var summary: String!
      var dTitle: String?
      var dDescription: String?
      var dImage: UIImage?
      var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        
        detailsImg.image = dImage
        detailsTitle.text = dTitle
        detailsDescription.text = dDescription

        }
    override func viewDidAppear(animated: Bool) {
 //        let frame = CGRectMake(0, 0, containerSummary.bounds.width, containerSummary.bounds.height)
  //      webView.frame = frame
        //loadRequest()
    }
    func loadRequest(urlStr: String) {
        let url = NSURL(string: urlStr)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
}
