//
//  Constants.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 09/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import Foundation

// Language
var LANGUAGE: String = "pl"


// Flickr API
let API_KEY = "f5ef0151fe94b234be7d73ed2e8fd505"
let SECRET = "3939738c4f94a3d6"

// Segues
let TO_POP_VC = "PopVC"

// Functions
func flickrGetPhotosForLocation(withAnnotation annotation: DropablePin, andNumberOfPhotos number: Int) -> String {
    let url = "https://www.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(API_KEY)&lat=\(annotation.coordinate.latitude)&lon=\(annotation.coordinate.longitude)&radius=1&radius_units=km&per_page=\(number)&format=json&nojsoncallback=1"
    
    return url
}

func flickrGetPhotoDetails(forId id: String) -> String  {
    let url = "https://api.flickr.com/services/rest/?api_key=\(API_KEY)&format=json&method=flickr.photos.getInfo&photo_id=\(id)&nojsoncallback=1"
    
    return url
}
