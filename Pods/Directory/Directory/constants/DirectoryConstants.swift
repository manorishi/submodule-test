//
//  DirectoryConstants.swift
//  Directory
//
//  Created by kunal singh on 23/03/17.
//  Copyright © 2017 Enparadigm. All rights reserved.
//

import Foundation
import Core

struct DirectoryConstants {
    static let galleryCollectionCellIDentifier = "GalleryCollectionViewCellIdentifier"
    static let POSTER_PLACEHOLDER_IMAGE: String = "default_placeholder.png"
}

struct DirectoryURLConstants {
    static let addFavouriteUrl = URLConstants.BASE_URL + "/addFavorite"
    static let removeFavouriteUrl = URLConstants.BASE_URL + "/removeFavorite"
    static let getUserFavouriteUrl = URLConstants.BASE_URL + "/getUserFavorites"
    static let updateUserFavouriteUrl = URLConstants.BASE_URL + "/updateUserFavorites"
}
