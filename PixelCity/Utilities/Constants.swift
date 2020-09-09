//
//  Constants.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 09/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import Foundation

let API_KEY = "f5ef0151fe94b234be7d73ed2e8fd505"
let SECRET = "3939738c4f94a3d6"

// https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=7f1dcb2ca9f1186a88a3a32ff1a64971&lat=52.260699&lon=21.097544&radius=1&radius_units=km&per_page=40&format=json&nojsoncallback=1

func flickrURL(_ apiKey: String, withAnnotation annotation: DropablePin, andNumberOfPhotos number: Int) -> String {
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(number)&format=json&nojsoncallback=1"
    
    return url
}
