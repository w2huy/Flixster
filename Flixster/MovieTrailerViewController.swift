//
//  MovieTrailerViewController.swift
//  Flixster
//
//  Created by William Huynh on 10/25/19.
//  Copyright © 2019 wi2. All rights reserved.
//

import UIKit
import WebKit

class MovieTrailerViewController: UIViewController, WKUIDelegate {

    //MARK: - Properties
    
    var movie: [String:Any]!
    var trailers: [[String:Any]]!
    @IBOutlet var webView: WKWebView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let id = movie["id"]!
        
        let url = URL(string: "https://api.themoviedb.org/3/movie/\(id)/videos?api_key=a07e22bc18f5cb106bfe4cc1f83ad8ed")!
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalCacheData, timeoutInterval: 10)
        let session = URLSession(configuration: .default, delegate: nil, delegateQueue: OperationQueue.main)
        let task = session.dataTask(with: request) { (data, response, error) in
            // This will run when the network request returns
            if let error = error {
                print(error.localizedDescription)
            } else if let data = data {
                let dataDictionary = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                
                self.trailers = dataDictionary["results"] as? [[String:Any]]
                // print(self.trailers!)
                self.webView.reload()
                
                let site = self.trailers[0]["site"] as! String
                let key = self.trailers[0]["key"] as! String
                
                if site == "YouTube" {
                    let myURL = URL(string:"https://www.youtube.com/watch?v=\(key)")
                    let myRequest = URLRequest(url: myURL!)
                    self.webView.load(myRequest)
                }
            }
        }
        task.resume()
        
        // Do any additional setup after loading the view.
        
//        let myURL = URL(string:"https://www.youtube.com/watch?v=\(String(describing: key))")
//        let myRequest = URLRequest(url: myURL!)
//        webView.load(myRequest)
    }
    
    override func loadView() {
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfiguration)
        webView.uiDelegate = self
        view = webView
    }
}
