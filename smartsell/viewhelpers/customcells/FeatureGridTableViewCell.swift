//
//  FeatureGridTableViewCell.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class FeatureGridTableViewCell: BaseHomeScreenTableViewCell {
    
    @IBOutlet weak var featureGridCollectionView: UICollectionView!
    
    let homeGridCollectionViewCellIdentifier = "FeatureGridCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCollectionViewCell()
        featureGridCollectionView.delegate = self
        featureGridCollectionView.dataSource = self
    }
    
    func registerCollectionViewCell(){
        featureGridCollectionView.register(UINib(nibName: homeGridCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: homeGridCollectionViewCellIdentifier)
    }

    
    
    var item: [ListItemTypeProtocol]? {
        didSet{
            featureGridCollectionView.reloadData()
        }
    }
    
}


extension FeatureGridTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = item?[indexPath.row] as? HomeScreenGridItem
        super.postNotification(type: HomeScreenItemType.grid as AnyObject, subtype: nil, data: selectedItem!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemWidth = (collectionView.bounds.width - 10.0) / 3.0
        return CGSize(width: itemWidth, height: itemWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = item else{
            return 0
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(0, 0, 0, 0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeGridCollectionViewCellIdentifier, for: indexPath) as? FeatureGridCollectionViewCell{
            cell.item = item?[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
}


