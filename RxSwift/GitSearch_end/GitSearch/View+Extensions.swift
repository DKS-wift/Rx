//
//  View+Extensions.swift
//  GitSearch
//
//  Created by 박의서 on 2023/06/26.
//

import UIKit

extension UIView {
    func addSubviews(_ views: UIView...) {
      views.forEach { self.addSubview($0) }
    }
}
