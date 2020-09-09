//
//  Constants.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 09/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import Foundation

// Flickr API
let API_KEY = "f5ef0151fe94b234be7d73ed2e8fd505"
let SECRET = "3939738c4f94a3d6"

// Segues
let TO_POP_VC = "PopVC"

func flickrURL(_ apiKey: String, withAnnotation annotation: DropablePin, andNumberOfPhotos number: Int) -> String {
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(number)&format=json&nojsoncallback=1"
    
    return url
}
