//
//  DirectoryGridCollectionViewCell.swift
//  Directory
//
//  Created by Apple on 23/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class DirectoryGridCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var newIconImageView: UIImageView!

    @IBOutlet weak var contentTypeImageView: UIImageView!
    @IBOutlet weak var contentImageView: UIImageView!
    @IBOutlet weak var contentTypeLabel: UILabel!
    @IBOutlet weak var contentTitleLabel: UILabel!
    @IBOutlet weak var contentDescriptionLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var moreOptionButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
