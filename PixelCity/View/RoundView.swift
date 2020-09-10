//
//  RoundView.swift
//  PixelCity
//
//  Created by Ścibor Budkowski on 10/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit

@IBDesignable
class RoundView: UIView {
    
    @IBInspectable var frameCornerRadius:CGFloat {
        set {
            self.layer.cornerRadius = newValue
        }
        get {
            return self.layer.cornerRadius
        }
    }

    override func awakeFromNib() {
        setupView()
    }
    
    func setupView() {
        self.layer.cornerRadius = frameCornerRadius
        self.clipsToBounds = true
    }
    
    override class func prepareForInterfaceBuilder() {
        super.prepareForInterfaceBuilder()
    }
}
