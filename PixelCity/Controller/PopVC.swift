//
//  PopVC.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 09/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit

class PopVC: UIViewController {

    @IBOutlet weak var popImageView: UIImageView!
    
    var passedImage: UIImage!
    
    func initData(forImage image: UIImage) {
        self.passedImage = image
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        popImageView.image = passedImage
    }
    
    @IBAction func closePressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
