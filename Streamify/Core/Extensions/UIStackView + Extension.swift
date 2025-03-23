//
//  UIStackView + Extension.swift
//  Streamify
//
//  Created by youngkyun park on 3/23/25.
//

import UIKit

extension UIStackView {
    func addArrangedSubviews(_ views: UIView...) {
        views.forEach {
            self.addArrangedSubview($0)
        }
    }
}

