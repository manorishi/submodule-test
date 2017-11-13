//
//  HomeBannerCarouselCollectionViewCell.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit
import SDWebImage

class HomeBannerCarouselCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var carouselItemBackImageView: UIImageView!
    @IBOutlet weak var carouselItemLabel: UILabel!
    @IBOutlet weak var title: UILabel!
    @IBOutlet weak var carouselDescription: UILabel!
    
    var item: ListItemTypeProtocol? {
        didSet{
            guard let item = item  as? HomeScreenCarouselItem else {
                return
            }
            title.text = item.title
            carouselDescription.text = item.description
            carouselItemLabel.text = item.actionText
            carouselItemBackImageView.sd_setImage(with: URL(string: item.imageUrl), placeholderImage: UIImage(named: "home_page_banner_placeholder"))
        }
    }
}
