//
//  NewsPresenter.swift
//  news
//
//  Created by Anurag Dake on 06/09/17.
//  Copyright © 2017 enParadigm. All rights reserved.
//

import UIKit
import Core

class NewsPresenter: NSObject{
    
    weak var newsViewController: NewsViewController!
    var newsInteractor: NewsInteractor!
    let tableCellEstimatedHeight: CGFloat = 120
    
    init(newsViewController: NewsViewController) {
        self.newsViewController = newsViewController
        newsInteractor = NewsInteractor()
    }
    
    func configure(tableView: UITableView, with cellIdentifier: String){
        let nib = UINib(nibName: cellIdentifier, bundle: BundleManager().loadResourceBundle(coder: self.classForCoder))
        tableView.register(nib, forCellReuseIdentifier: cellIdentifier)
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = tableCellEstimatedHeight
    }
    
    func newsdata(completionHandler:@escaping (_ newsList: [NewsItem]) -> ()){
        newsInteractor.newsData(completionHandler: completionHandler)
    }
}
