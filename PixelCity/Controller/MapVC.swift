//
//  ViewController.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 08/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit
import MapKit

class MapVC: UIViewController {

    @IBOutlet weak var mapView: MKMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        mapView.delegate = self
    }

    @IBAction func centerMapPressed(_ sender: Any) {
    }
    
}

extension MapVC: MKMapViewDelegate {
    
}
