//
//  NewsTableViewCell.swift
//  news
//
//  Created by Anurag Dake on 06/09/17.
//  Copyright © 2017 enParadigm. All rights reserved.
//

import UIKit

class NewsTableViewCell: UITableViewCell{
    
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newsIntroLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func setupCell(with newsItem: NewsItem){
        titleLabel.text = newsItem.newsTitle ?? ""
        newsIntroLabel.text = newsItem.newsIntro ?? ""
    }
    
}
