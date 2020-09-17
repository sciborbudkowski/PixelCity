//
//  CustomSegmentedControl.swift
//  RNDM
//
//  Created by Ścibor Budkowski on 11/09/2020.
//  Copyright © 2020 Ścibor Budkowski. All rights reserved.
//

import UIKit

@IBDesignable
class CustomSegmentedControl: UISegmentedControl {
    
    private var colorNormal: UIColor = UIColor.black
    private var colorSelected: UIColor = UIColor.white

    @IBInspectable var textColorForNormal: UIColor {
        set {
            self.colorNormal = newValue
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: newValue], for: .normal)
        }
        get {
            return self.colorNormal
        }
    }

    @IBInspectable var textColorForSelected: UIColor {
        set {
            self.colorSelected = newValue
            UISegmentedControl.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: newValue], for: .selected)
        }
        get {
            return self.colorSelected
        }
    }
}
