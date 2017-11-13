//
//  GalleryTableViewCell.swift
//  Directory
//
//  Created by Apple on 30/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import UIKit

class GalleryTableViewCell: UITableViewCell {

    @IBOutlet weak var galleryCollectionView: UICollectionView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerViewCell()
    }
    
    /**
     Register collection view cell.
     */
    func registerViewCell() {
        let podBundle = Bundle(for: self.classForCoder)
        if let bundleURL = podBundle.url(forResource: "Directory", withExtension: "bundle") {
            if let bundle = Bundle(url: bundleURL) {
                galleryCollectionView.register(UINib(nibName: "GalleryCollectionViewCell", bundle: bundle) , forCellWithReuseIdentifier: DirectoryConstants.galleryCollectionCellIDentifier)
            }
            else {
                assertionFailure("Could not load the bundle")
            }
        }
        else {
            assertionFailure("Could not create a path to the bundle")
        }
    }
}

extension GalleryTableViewCell {
    
    func setCollectionViewDataSourceDelegate<D: UICollectionViewDataSource & UICollectionViewDelegate>(_ dataSourceDelegate: D, forRow row: Int) {
        galleryCollectionView.delegate = dataSourceDelegate
        galleryCollectionView.dataSource = dataSourceDelegate
        galleryCollectionView.tag = row
        galleryCollectionView.reloadData()
    }
    
    
    
}
