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
    @IBOutlet weak var containerSummary: UIView!
    @IBOutlet weak var visitImdbBtn: UIButton!
    @IBOutlet weak var seeSummaryBtn: UIButton!
    var summary: String!
    var dTitle: String?
    var dDescription: String?
    var dImage: UIImage?
    var imdbLink: String!
    var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        webView = WKWebView()
        containerSummary.addSubview(webView)
        
        detailsImg.image = dImage
        detailsTitle.text = dTitle
        detailsDescription.text = dDescription
        }
    override func viewDidAppear(animated: Bool) {
        let frame = CGRectMake(0, 0, containerSummary.bounds.width, containerSummary.bounds.height)
        visitImdbBtn.layer.cornerRadius = 5.0
        seeSummaryBtn.layer.cornerRadius = 5.0
        webView.frame = frame
    }
    func loadRequest(urlStr: String) {
        let url = NSURL(string: urlStr)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }
    @IBAction func visitImdb(sender: AnyObject) {
        containerSummary.hidden = false
        loadRequest(imdbLink)
    }
    @IBAction func seeSummary(sender: AnyObject) {
        containerSummary.hidden = false
        loadRequest(summary)
    }
    @IBAction func backPressed(sender: AnyObject) {
        containerSummary.hidden = true
    }
}
