//
//  HomeScreenTableViewAdapter.swift
//  smartsell
//
//  Created by kunal singh on 10/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class HomeScreenTableViewAdapter : NSObject, UITableViewDelegate, UITableViewDataSource{
    var dataList:[[ListItemTypeProtocol]]?
    private let homeBannerCarouselTableViewCellIdentifier = "HomeBannerCarouselTableViewCell"
    private let dailyChallengeTableViewCellIdentifier = "DailyChallengeTableViewCell"
    private let featureGridTableViewCellIdentifier = "FeatureGridTableViewCell"
    private let bannerTableViewCellIdentifier = "BannerTableViewCell"
    private var heightAtIndexPath = NSMutableDictionary()
    var currentCell: HomeBannerCarouselTableViewCell?
    var x = 1
    var timer = Timer()
    
    func homeBannerCarouselTableViewCell() -> UINib{
        return UINib(nibName: homeBannerCarouselTableViewCellIdentifier, bundle: nil)
    }
    
    func dailyChallengeTableViewCell() -> UINib{
        return UINib(nibName: dailyChallengeTableViewCellIdentifier, bundle: nil)
    }
    
    func featureGridTableViewCell() -> UINib{
        return UINib(nibName: featureGridTableViewCellIdentifier, bundle: nil)
    }
    
    func bannerTableViewCell() -> UINib{
        return UINib(nibName: bannerTableViewCellIdentifier, bundle: nil)
    }
    
    func  homeBannerCarouselCellReuseIdentifier() -> String{
        return homeBannerCarouselTableViewCellIdentifier
    }
    
    func dailyChallengeCellReuseIdentifier() -> String{
        return dailyChallengeTableViewCellIdentifier
    }
    
    func featureGridCellReuseIdentifier() -> String{
        return featureGridTableViewCellIdentifier
    }
    
    func bannerCellReuseIdentifier() -> String{
        return bannerTableViewCellIdentifier
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let item = dataList![indexPath.row]
        switch item[0].homeScreenItemType!(){
        case .grid:
            let itemWidth = (tableView.bounds.size.width - 10.0) / 3.0
            return 3 * itemWidth + 2 * 5.0 - 10.0
        default:
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        if let height = heightAtIndexPath.object(forKey: indexPath) as? NSNumber {
            return CGFloat(height.floatValue)
        } else {
            return UITableViewAutomaticDimension
        }
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let height = NSNumber(value: Float(cell.frame.size.height))
        heightAtIndexPath.setObject(height, forKey: indexPath as NSCopying)
    }

    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataList != nil ? dataList!.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let item = dataList![indexPath.row]
        switch item[0].homeScreenItemType!() {
        case .carousel:
            if let cell = tableView.dequeueReusableCell(withIdentifier: homeBannerCarouselTableViewCellIdentifier, for: indexPath) as? HomeBannerCarouselTableViewCell {
                cell.item = item
                currentCell = cell
                return cell
            }
        case .challenge:
            if let cell = tableView.dequeueReusableCell(withIdentifier: dailyChallengeTableViewCellIdentifier, for: indexPath) as? DailyChallengeTableViewCell {
                cell.item = item
                return cell
            }
        case .grid:
            if let cell = tableView.dequeueReusableCell(withIdentifier: featureGridTableViewCellIdentifier, for: indexPath) as? FeatureGridTableViewCell {
                cell.item = item
                return cell
            }
        case .banner:
            if let cell = tableView.dequeueReusableCell(withIdentifier: bannerTableViewCellIdentifier, for: indexPath) as? BannerTableViewCell {
                cell.item = item
                return cell
            }
        }
        return UITableViewCell()
    }
    
    func startCarouselScroll(){
        guard let dataList = self.dataList, dataList.count > 0 else{
            return
        }
        if dataList.count > 0{
            if self.x < dataList[0].count {
                let indexPath = IndexPath(item: x, section: 0)
                self.currentCell?.carouselCollectionView.scrollToItem(at: indexPath, at: .left, animated: true)
                self.x = self.x + 1
            } else {
                self.x = 0
                self.currentCell?.carouselCollectionView.scrollToItem(at: IndexPath(item: 0, section: 0), at: .centeredHorizontally, animated: true)
            }
        }
    }
    
    func startAutoScroll() {
        timer = Timer.scheduledTimer(timeInterval: 5.0, target: self, selector: #selector(HomeScreenTableViewAdapter.startCarouselScroll), userInfo: nil, repeats: true)
    }
    
    func stopAutoScroll(){
        timer.invalidate()
    }

}
