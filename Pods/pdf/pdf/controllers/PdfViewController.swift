//
//  PdfViewController.swift
//  pdf
//
//  Created by kunal singh on 01/04/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import UIKit
import CoreData

/**
 PdfViewController displays fetched pdf from db
 */
public class PdfViewController: UIViewController {

    @IBOutlet weak var pdfTitleLabel: UILabel!
    @IBOutlet weak var pdfWebView: UIWebView!
    
    var pdfPresenter: PdfPresenter!
    private var pdfImageFullUrl: URL?
    
    public var pdfUrl: String?
    public var pdfFileName: String?
    public var pdfDescription: String?
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        pdfPresenter = PdfPresenter(pdfViewController: self)
        loadTitle()
        showPdf()
    }
    
    func loadTitle(){
        if let description = pdfDescription{
            pdfTitleLabel.text = description
        }
    }
    
    /**
     Fetch pdf and display in webview
     */
    func showPdf(){
        if let fileName = pdfFileName{
            if let pdfImageFullUrl = pdfPresenter.pdfFullUrl(pdfFileName: fileName){
                self.pdfImageFullUrl = pdfImageFullUrl
                do {
                    let data = try Data(contentsOf: pdfImageFullUrl)
                    pdfWebView.load(data, mimeType: "application/pdf", textEncodingName: "UTF-8", baseURL: pdfImageFullUrl)
                }
                catch {
                    // catch errors here
                }
            }
        }
    }
    
    @IBAction func shareButtonPressed(_ sender: UIButton) {
        guard let pdfUrl = pdfImageFullUrl else {
            return
        }
        pdfPresenter.showShareActivityController(shareUrl: pdfUrl)
    }
    
    @IBAction func closePressed(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
