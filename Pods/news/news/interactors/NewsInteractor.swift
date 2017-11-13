//
//  NewsInteractor.swift
//  news
//
//  Created by Anurag Dake on 06/09/17.
//  Copyright © 2017 enParadigm. All rights reserved.
//

import Foundation
import Core

public class NewsInteractor{
    
    var newsManager: NewsManager!
    
    public init() {
        newsManager = NewsManager()
    }
    
    /**
     Function to fetch first news item
     */
    public func topNewsItem(completionHandler:@escaping (_ newsItem: NewsItem?) -> ()){
        var newsSource1: [NewsItem] = []
        newsDataFromSource1(noOfArticles: 1) { (status, items) in
            DispatchQueue.main.async{
                newsSource1.append(contentsOf: items)
                completionHandler(newsSource1.first)
            }
        }
    }
    
    func newsData(completionHandler:@escaping (_ newsList: [NewsItem]) -> ()){
        var newsSource1: [NewsItem] = [], newsSource2: [NewsItem] = [], newsSource3: [NewsItem] = []
        let noOfSources = 3
        var responseFrom = 0
        
        newsDataFromSource1 { [weak self] (status, items) in
            DispatchQueue.main.async{
                responseFrom = responseFrom + 1
                newsSource1.append(contentsOf: items)
                if responseFrom == noOfSources{
                    completionHandler(self?.newsArticles(newsSource1: newsSource1, newsSource2: newsSource2, newsSource3: newsSource3) ?? [])
                }
            }
        }
        
        newsDataFromSource2 { [weak self] (status, items) in
            DispatchQueue.main.async{
                responseFrom = responseFrom + 1
                newsSource2.append(contentsOf: items)
                if responseFrom == noOfSources{
                    completionHandler(self?.newsArticles(newsSource1: newsSource1, newsSource2: newsSource2, newsSource3: newsSource3) ?? [])
                }
            }
        }
        
        newsDataFromSource3 { [weak self] (status, items) in
            DispatchQueue.main.async{
                responseFrom = responseFrom + 1
                newsSource3.append(contentsOf: items)
                if responseFrom == noOfSources{
                    completionHandler(self?.newsArticles(newsSource1: newsSource1, newsSource2: newsSource2, newsSource3: newsSource3) ?? [])
                }
            }
        }
    }
    
    func newsArticles(newsSource1: [NewsItem], newsSource2: [NewsItem], newsSource3: [NewsItem]) -> [NewsItem]{
        var newsArticles: [NewsItem] = []
        newsArticles.append(contentsOf: newsSource1)
        newsArticles.append(contentsOf: newsSource2)
        newsArticles.append(contentsOf: newsSource3)
        return newsArticles
    }
    
    func newsDataFromSource1(noOfArticles: Int = 10, completionHandler:@escaping (_ status:Bool, _ newsList: [NewsItem]) -> ()){
        NetworkService.sharedInstance.networkClient?.doHtmlRequest(requestType: "GET", requestURL: NewsURLConstants.newsSource1, headers: nil, params: nil, httpBody: nil, completionHandler: { [weak self] (responseStatus, response) in
            
            switch responseStatus{
            case .success:
                completionHandler(true, self?.newsManager.parseAndGetNewsArticlesFromSource1(html: response, noOfArticles: noOfArticles) ?? [])
            case .error:
                completionHandler(false, [])
            default:
                completionHandler(false, [])
            }
            
        })
    }
    
    func newsDataFromSource2(noOfArticles: Int = 5, completionHandler:@escaping (_ status:Bool, _ newsList: [NewsItem]) -> ()){
        let header = ["referer" : "https://www.valueresearchonline.com/ads/splash.asp?cid=1&ref=%2FDefault%2Easp%3F"]
        NetworkService.sharedInstance.networkClient?.doHtmlRequest(requestType: "GET", requestURL: NewsURLConstants.newsSource2, headers: header, params: nil, httpBody: nil, completionHandler: { [weak self] (responseStatus, response) in
            
            switch responseStatus{
            case .success:
                completionHandler(true, self?.newsManager.parseAndGetNewsArticlesFromSource2(html: response) ?? [])
            case .error:
                completionHandler(false, [])
            default:
                completionHandler(false, [])
            }
            
        })
    }
    
    func newsDataFromSource3(noOfArticles: Int = 5, completionHandler:@escaping (_ status:Bool, _ newsList: [NewsItem]) -> ()){
        NetworkService.sharedInstance.networkClient?.doHtmlRequest(requestType: "GET", requestURL: NewsURLConstants.newsSource3, headers: nil, params: nil, httpBody: nil, completionHandler: { [weak self] (responseStatus, response) in
            
            switch responseStatus{
            case .success:
                completionHandler(true, self?.newsManager.parseAndGetNewsArticlesFromSource3(html: response) ?? [])
            case .error:
                completionHandler(false, [])
            default:
                completionHandler(false, [])
            }
            
        })
    }
}
