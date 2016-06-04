//
//  IMDBWebVC.swift
//  FavoriteMovie
//
//  Created by sanchez on 16.12.15.
//  Copyright © 2015 KOT LLC. All rights reserved.
//

import UIKit
import WebKit

class IMDBWebVC: UIViewController {
    
    @IBOutlet weak var container: UIView!
    var webView: WKWebView!
    
    var movieID = ""
    
    var imdbUrl = "http://www.imdb.com/title/"

    override func viewDidLoad() {
        super.viewDidLoad()
        
        webView = WKWebView()
        container.addSubview(webView)
        imdbUrl.appendContentsOf(movieID)
        loadRequest(imdbUrl)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let frame = CGRectMake(0, 0, container.bounds.width, container.bounds.height)
        webView.frame = frame
    }
    
    @IBAction func backPressed(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func loadRequest(urlString: String) {
        let url = NSURL(string: urlString)!
        let request = NSURLRequest(URL: url)
        webView.loadRequest(request)
    }

}
