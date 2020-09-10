//
//  CircleButton.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 10/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit

@IBDesignable
class CircleButton: UIButton {

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = self.frame.width / 2
        self.clipsToBounds = true
    }
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
