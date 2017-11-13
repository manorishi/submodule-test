//
//  FeatureGridCollectionViewCell.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class FeatureGridCollectionViewCell: UICollectionViewCell {
    
    @IBOutlet weak var featureGridImageView: UIImageView!
    
    var item: ListItemTypeProtocol? {
        didSet{
            guard let item = item  as? HomeScreenGridItem else {
                return
            }
            featureGridImageView.image = UIImage(named: item.backImage)
        }
    }
    
    
}
