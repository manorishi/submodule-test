//
//  ContentItemCollectionViewCell.swift
//  smartsell
//
//  Created by Anurag Dake on 17/03/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class ContentItemCollectionViewCell : UICollectionViewCell{
    
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentType: UILabel!
    @IBOutlet weak var contentTitle: UILabel!
    @IBOutlet weak var contentDescription: UILabel!
    @IBOutlet weak var moreOptionButton: UIButton!
    @IBOutlet weak var likeButton: UIButton!
}
