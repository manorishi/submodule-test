//
//  VideoPlayViewController.swift
//  Video
//
//  Created by Anurag Dake on 06/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit
import Core

/**
 VideoPlayViewController plays selected youtube video in webview iframe with full screen.
 */
class VideoPlayViewController: UIViewController, UIWebViewDelegate{
    
    @IBOutlet weak var videoWebView: UIWebView!
    var videoItem: VideoItem?
    var allowedRedirect = true
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        UIDevice.current.setValue(Int(UIInterfaceOrientation.landscapeRight.rawValue), forKey: "orientation")
        initialiseVideoWebView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadData()
    }
    /**
     Initialise webview for playing video
     */
    private func initialiseVideoWebView(){
        videoWebView.delegate = self
        videoWebView.scrollView.bounces = false
        videoWebView.scrollView.isScrollEnabled = false
        videoWebView.allowsInlineMediaPlayback = true
    }
    
    func canRotate() -> Void {}
    
    /**
     Load video url in webview in fullscreen mode
     */
    func loadData(){
        if let videoItem = videoItem{
            guard let youtubeURL = videoItem.videoURL else { return }
            let videoHeight = String(Int(videoWebView.frame.height))
            let videoWidth = String(Int(videoWebView.frame.width))
            let videoId = youTubeVideoId(from: youtubeURL)
            let embededHTML = "<html><body><style>body,html,iframe{margin:0;padding:0;}</style><iframe src=\"http://www.youtube.com/embed/\(videoId)?playsinline=1&fs=0&showinfo=0&rel=0&autoplay=1\" width=\"\(videoWidth)\" height=\"\(videoHeight)\" frameborder=\"0\" allowfullscreen=\"0\")></iframe></body></html>"
            videoWebView.loadHTMLString(embededHTML, baseURL: Bundle.main.resourceURL)
        }
    }
    
    func webViewDidFinishLoad(_ webView: UIWebView) {
        allowedRedirect = false
    }
    
    func webView(_ webView: UIWebView, shouldStartLoadWith request: URLRequest, navigationType: UIWebViewNavigationType) -> Bool {
        return allowedRedirect
    }
    
    /**
     Override shouldAutorotate property to false
     */
    override var shouldAutorotate: Bool{
        return false
    }
    
    override var preferredInterfaceOrientationForPresentation: UIInterfaceOrientation{
        return .landscapeRight
    }
    
    /**
     Extract youtube video id from url
     */
    func youTubeVideoId(from urlString: String) -> String{
        if let index = urlString.characters.index(of: "?"){
            return urlString.substring(from: urlString.characters.index(index, offsetBy: 3))
        }
        return ""
    }
    
    /**
     Dismiss controller on back press
     */
    @IBAction func onBackButtonPress(_ sender: UIButton) {
        dismiss(animated: true, completion: nil)
    }
}
