//
//  BannerTableViewCell.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import SDWebImage

class BannerTableViewCell: BaseHomeScreenTableViewCell {
    
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var bannerLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var bannerDescription: UILabel!
    
    
    var item: [ListItemTypeProtocol]? {
        didSet{
            guard let item = item  as? [HomeScreenBannerItem] else {
                return
            }
            title.text = item[0].title
            bannerDescription.text = item[0].description
            bannerLabel.text = item[0].actionText
            bannerImageView.sd_setImage(with: URL(string: item[0].imageUrl), placeholderImage: UIImage(named: "home_page_banner_placeholder"))
            attachListenerToBannerImage(itemId: item[0].itemId)
        }
    }
    
    private func attachListenerToBannerImage(itemId: Int32){
        bannerImageView.tag = Int(itemId)
        bannerImageView.isUserInteractionEnabled = true
        bannerImageView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(imagePressed(sender:))))
    }
    
    @objc private func imagePressed(sender: UITapGestureRecognizer){
        guard let bannerItem = item else {
            return
        }
        postNotification(type: HomeScreenItemType.banner as AnyObject, subtype: nil, data:  bannerItem[0] as AnyObject)
    }
    
    
}
