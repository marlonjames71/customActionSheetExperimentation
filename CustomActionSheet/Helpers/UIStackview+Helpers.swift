//
//  UIStackview+Helpers.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/22/21.
//

import UIKit

public extension UIStackView {
    
    /// Adds multiple views as arranged subviews
    func addArrangedSubviews(_ views: [UIView]) {
        views.forEach { view in addArrangedSubview(view) }
    }
}
