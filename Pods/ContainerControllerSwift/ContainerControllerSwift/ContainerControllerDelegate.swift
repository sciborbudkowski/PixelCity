//
//  ContainerView.swift
//  PatternsSwift
//
//  Created by mrustaa on 21/04/2020.
//  Copyright © 2020 mrustaa. All rights reserved.
//

import UIKit

public protocol ContainerControllerDelegate {
    
    /// Reports rotation and orientation changes
    func containerControllerRotation(_ containerController: ContainerController)
    
    /// Reports a click on the background shadow
    func containerControllerShadowClick(_ containerController: ContainerController)
    
    /// Reports the changes current position of the container, after its use
    func containerControllerMove(_ containerController: ContainerController, position: CGFloat, type: ContainerMoveType, animation: Bool)
    
}

public extension ContainerControllerDelegate {
    
    func containerControllerRotation(_ containerController: ContainerController) {
    }
    
    
    func containerControllerShadowClick(_ containerController: ContainerController) {
    }
    
    func containerControllerMove(_ containerController: ContainerController, position: CGFloat, type: ContainerMoveType, animation: Bool) {
    }
}

