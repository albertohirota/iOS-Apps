//
//  DetailsVC.swift
//  MovieApp2
//
//  Created by Alberto Hirota on 8/14/16.
//  Copyright © 2016 Alberto Hirota. All rights reserved.
//

import UIKit

class DetailsVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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



//import UIKit
//import WebKit
//
//class DetailsVC: UIViewController {
//    
//    @IBOutlet weak var detailsImg: UIImageView!
//    @IBOutlet weak var detailsTitle: UILabel!
//    @IBOutlet weak var detailsDescription: UILabel!
//    @IBOutlet weak var containerSummary: UIView!
//    
//    var summary: String!
//    var dTitle: String?
//    var dDescription: String?
//    var dImage: UIImage?
//    
//    var webView: WKWebView!
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        webView = WKWebView()
//        //NSTimer.scheduledTimerWithTimeInterval(10.0, target: self, selector: #selector(DetailsVC.exec), userInfo: nil, repeats: false)
//        detailsTitle.text = dTitle
//        detailsDescription.text = dDescription
//        detailsImg.image = dImage
//        containerSummary.addSubview(webView)
//    }
//    
//    override func viewDidAppear(animated: Bool) {
//        // let frame = CGRectMake(0, 0, containerSummary.bounds.width, containerSummary.bounds.height)
//        //webView.frame = frame
//        loadRequest(summary)
//    }
//    func loadRequest(urlStr: String) {
//        let url = NSURL(string: urlStr)!
//        let request = NSURLRequest(URL: url)
//        webView.loadRequest(request)
//    }
//    @IBAction func updateBtn (sender: AnyObject) {
//        detailsTitle.text = dTitle
//        detailsDescription.text = dDescription
//        detailsImg.image = dImage
//        containerSummary.addSubview(webView)
//    }
//    
//}
