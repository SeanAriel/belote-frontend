//
//  UIView+aspectRatio.swift
//  Belote
//
//  Created by Sitora Guliamova on 30.05.2022.
//

import UIKit

extension UIView {
    func aspectRatio(multiplier: CGFloat = 1) {
        self.heightAnchor.constraint(equalTo: self.widthAnchor, multiplier: multiplier).isActive = true
    }
}

