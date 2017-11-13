//
//  NewsViewController.swift
//  news
//
//  Created by Anurag Dake on 06/09/17.
//  Copyright © 2017 enParadigm. All rights reserved.
//

import UIKit
import Core

public class NewsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource{
    
    @IBOutlet weak var newsTableView: UITableView!
    
    var newsPresenter : NewsPresenter!
    
    let newsCellNIB = "NewsTableViewCell"
    var newsArticles: [NewsItem] = []
    
    override public func viewDidLoad() {
        super.viewDidLoad()
        newsPresenter = NewsPresenter(newsViewController: self)
        initialiseView()
        newsdata()
    }
    
    func initialiseView(){
        initialiseTableView()
    }
    
    func newsdata(){
        let alertViewHelper = AlertViewHelper(alertViewCallbackProtocol: nil)
        let loadingController = alertViewHelper.loadingAlertViewController(title: "Loading...", message: "\n\n")
        self.present(loadingController, animated: false, completion: nil)
        
        newsPresenter.newsdata { [weak self] (newsArticles) in
            DispatchQueue.main.async {
                self?.dismiss(animated: false, completion: {
                    self?.newsArticles.removeAll()
                    self?.newsArticles.append(contentsOf: newsArticles)
                    self?.newsTableView.reloadData()
                })
            }
        }
    }
    
    func initialiseTableView(){
        newsTableView.delegate = self
        newsTableView.dataSource = self
        newsPresenter.configure(tableView: newsTableView, with: newsCellNIB)
    }
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return newsArticles.count
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: NewsTableViewCell! = tableView.dequeueReusableCell(withIdentifier: newsCellNIB) as? NewsTableViewCell
        cell.setupCell(with: newsArticles[indexPath.row])
        cell.updateConstraintsIfNeeded()
        return cell
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let newsItem = newsArticles[indexPath.row]
        var newsDetailsVC: NewsDetailsViewController?
        let podBundle = Bundle(for: NewsDetailsViewController.classForCoder())
        if let bundleURL = podBundle.url(forResource: "news", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                newsDetailsVC = NewsDetailsViewController(nibName: "NewsDetailsViewController", bundle: bundle)
                newsDetailsVC?.newsSourceUrl = newsItem.newsURL
                newsDetailsVC?.newsTitle = newsItem.newsTitle
                self.navigationController?.pushViewController(newsDetailsVC!, animated: true)
            }
        }
    }
    
    @IBAction func onBackButtonTap(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
