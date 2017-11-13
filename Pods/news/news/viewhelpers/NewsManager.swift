//
//  NewsManager.swift
//  news
//
//  Created by Anurag Dake on 07/09/17.
//  Copyright © 2017 enParadigm. All rights reserved.
//

import Foundation
import Kanna


public class NewsManager{
    
    func parseAndGetNewsArticlesFromSource1(html: String?, noOfArticles: Int = 10) -> [NewsItem]{
        guard let htmlText = html, let doc = HTML(html: htmlText, encoding: .utf8) else {
            return []
        }
        var newsItems = [NewsItem]()
        for item in doc.xpath("//div[@id='articles']/div[@class='cf article-group']") {
            let newsItem = NewsItem()
            newsItem.newsTitle = item.at_xpath("a")?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            if let introDiv = item.at_xpath("div[@class='art-desc']"), let child = introDiv.at_xpath("div[@class='art-info']"){
                introDiv.removeChild(child)
            }
            
            newsItem.newsIntro = item.at_xpath("div[@class='art-desc']")?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            newsItem.newsURL = item.at_xpath("a")?["href"]?.trimmingCharacters(in: .whitespacesAndNewlines)
            newsItems.append(newsItem)
            if newsItems.count == noOfArticles{
                break
            }
        }
        return newsItems
    }
    
    func parseAndGetNewsArticlesFromSource2(html: String?, noOfArticles: Int = 5) -> [NewsItem]{
        guard let htmlText = html, let doc = HTML(html: htmlText, encoding: .utf8) else {
            return []
        }
        var newsItems = [NewsItem]()
        for item in doc.xpath("//div[@class='storysection']/div[@class='story']/div[@class='story_col_right']") {
            let newsItem = NewsItem()
            let storyHeading = item.at_xpath("div[@class='story_heading']")
            newsItem.newsTitle = storyHeading?.at_xpath("a")?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            newsItem.newsIntro = item.at_xpath("div[@class='story_intro']")?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            newsItem.newsURL = "\(NewsURLConstants.newsSource2)\(storyHeading?.at_xpath("a")?["href"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")"
            newsItems.append(newsItem)
            if newsItems.count == noOfArticles{
                break
            }

        }
        return newsItems
    }
    
    func parseAndGetNewsArticlesFromSource3(html: String?, noOfArticles: Int = 5) -> [NewsItem]{
        guard let htmlText = html, let doc = HTML(html: htmlText, encoding: .utf8) else {
            return []
        }
        var newsItems = [NewsItem]()
        for item in doc.xpath("//div[@class='abc stories_main_div']/div[@class='maindiv']") {
            let newsItem = NewsItem()
            let storyHeading = item.at_xpath("div[@class='storyhead']")
            newsItem.newsTitle = storyHeading?.at_xpath("a")?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            newsItem.newsURL = "\(NewsURLConstants.newsSource2)\(storyHeading?.at_xpath("a")?["href"]?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")"
            
            for subitem in item.xpath("div[@class='storysubhead']/span[@class='storydate']"){
                item.removeChild(subitem)
            }
            newsItem.newsIntro = item.at_xpath("div[@class='storysubhead']")?.text?.trimmingCharacters(in: .whitespacesAndNewlines)
            newsItems.append(newsItem)
            if newsItems.count == noOfArticles{
                break
            }
        }
        return newsItems
    }
    
}
