//
//  NewsDetailsViewController.swift
//  news
//
//  Created by Anurag Dake on 06/09/17.
//  Copyright © 2017 enParadigm. All rights reserved.
//

import UIKit

class NewsDetailsViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var newsTitleLabel: UILabel!
    @IBOutlet weak var newsWebView: UIWebView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var newsSourceUrl: String?
    var newsTitle: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialiseView()
        loadPage()
    }
    
    func initialiseView(){
        newsWebView.delegate = self
        activityIndicator.color = UIColor.gray
        newsTitleLabel.text = newsTitle ?? "News Details"
    }
    
    func loadPage(){
        guard let urlString = newsSourceUrl, let url = URL(string: urlString) else{
            return
        }
        let request = URLRequest(url: url)
        newsWebView.loadRequest(request)
    }
    
    func webViewDidStartLoad(_ webView: UIWebView) {
        activityIndicator.startAnimating()
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        activityIndicator.stopAnimating()
    }
    
    func webView(_ webView: UIWebView, didFailLoadWithError error: Error) {
        activityIndicator.stopAnimating()
    }
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
