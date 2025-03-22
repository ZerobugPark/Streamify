//
//  UIView+Extension.swift
//  Streamify
//
//  Created by youngkyun park on 3/22/25.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
        views.forEach {
            self.addSubview($0)
        }
    }
}
