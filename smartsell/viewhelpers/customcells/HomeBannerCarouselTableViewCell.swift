//
//  HomeBannerCarousel.swift
//  smartsell
//
//  Created by kunal singh on 11/09/17.
//  Copyright © 2017 Cybrilla. All rights reserved.
//

import UIKit

class HomeBannerCarouselTableViewCell: BaseHomeScreenTableViewCell{
    
    
    @IBOutlet weak var carouselCollectionView: UICollectionView!
    
    let homeCarouselCollectionViewCellIdentifier = "HomeBannerCarouselCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        registerCollectionViewCell()
        carouselCollectionView.delegate = self
        carouselCollectionView.dataSource = self
    }
    
    func registerCollectionViewCell(){
        carouselCollectionView.register(UINib(nibName: homeCarouselCollectionViewCellIdentifier, bundle: nil), forCellWithReuseIdentifier: homeCarouselCollectionViewCellIdentifier)
    }
    
    
    var item: [ListItemTypeProtocol]? {
        didSet{
            carouselCollectionView.reloadData()
        }
    }
}


extension HomeBannerCarouselTableViewCell: UICollectionViewDelegateFlowLayout, UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedItem = item?[indexPath.row] as? HomeScreenCarouselItem
        super.postNotification(type: HomeScreenItemType.carousel as AnyObject, subtype: nil, data: selectedItem!)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.bounds.width - 15, height: 130)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let items = item else{
            return 0
        }
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let cell = collectionView.dequeueReusableCell(withReuseIdentifier: homeCarouselCollectionViewCellIdentifier, for: indexPath) as? HomeBannerCarouselCollectionViewCell{
            cell.item = item?[indexPath.row]
            return cell
        }
        return UICollectionViewCell()
    }
    
}

