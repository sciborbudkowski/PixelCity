//
//  DropablePin.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 08/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit
import MapKit

class DropablePin: NSObject, MKAnnotation {
    
    dynamic var coordinate: CLLocationCoordinate2D
    var identifier: String
    
    init(coordinate: CLLocationCoordinate2D, identifier: String) {
        self.coordinate = coordinate
        self.identifier = identifier
        super.init()
    }
}
