//
//  UIStackView+remove.swift
//  Belote
//
//  Created by Sitora Guliamova on 30.05.2022.
//

import UIKit

extension UIStackView {
    func removeFully(view: UIView) {
        removeArrangedSubview(view)
        view.removeFromSuperview()
    }

    func removeFullyAllArrangedSubviews() {
        arrangedSubviews.forEach { (view) in
            removeFully(view: view)
        }
    }
}
