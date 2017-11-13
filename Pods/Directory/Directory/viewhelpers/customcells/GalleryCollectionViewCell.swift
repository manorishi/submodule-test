//
//  GalleryCollectionViewCell.swift
//  Directory
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class GalleryCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var newIconImageView: UIImageView!
    @IBOutlet weak var contentTypeImageView: UIImageView!   
    @IBOutlet weak var moreOptionButton: CustomTaggedButton!
    @IBOutlet weak var likeButton: CustomTaggedButton!
    @IBOutlet weak var contentTypeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
