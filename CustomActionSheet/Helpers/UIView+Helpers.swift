//
//  UIView+Helpers.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/22/21.
//

import UIKit

// MARK: -  Adding Views

extension UIView {
    
    /// Adds the given view as a subview while turning `translatesAutoresizingMaskIntoConstraints` off.
    ///
    /// - Parameters:
    ///     - view: The given view to be added as a subview
    ///
    public func addConstrainedView(_ view: UIView) {
        view.translatesAutoresizingMaskIntoConstraints = false
        addSubview(view)
    }
    
    /// Adds the given views as subviews while turning `translatesAutoresizingMaskIntoConstraints`
    /// off for each given view.
    ///
    /// - Parameters:
    ///     - views: The given views to be added as subviews
    ///
    public func addConstrainedViews(_ views: UIView...) {
        views.forEach { view in addConstrainedView(view) }
    }
}


// MARK: -  Rounded Corners

extension UIView {
    
    /// Applies rounded corners with masking to specific corners and with corner curve option.
    func roundCornersWithMask(cornerRadius: CGFloat,
                              roundedStyle: CALayerCornerCurve = .continuous,
                              corners: CACornerMask) {
        layer.cornerRadius = cornerRadius
        layer.cornerCurve = roundedStyle
        layer.maskedCorners = corners
    }
    
    func curveCorners(radius: CGFloat, curve: CALayerCornerCurve = .continuous) {
        layer.cornerRadius = radius
        layer.cornerCurve = curve
    }
}


// MARK: -  Layout

extension UIView {
    /// Adds `self` as a subview to the given view and then gets pinned to its new parent with the option of providing edge insets
    func pin(to view: UIView, withInsets insets: UIEdgeInsets? = nil) {
        view.addSubview(self)
        
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: insets?.top ?? 0),
            self.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -(insets?.right ?? 0)),
            self.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -(insets?.bottom ?? 0)),
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: insets?.left ?? 0),
        ])
    }
    
    
    
    /// Sets `translatesAutoresizingMaskIntoConstraints` to false.
    ///
    ///     // Example Usage:
    ///
    ///     private lazy var captionLabel: UILabel = {
    ///         let label = UILabel().forAutoLayout()
    ///         label.text = viewModel.captionText
    ///         label.textAlignment = .center
    ///         return label
    ///     }
    ///
    /// - Returns: `Self` for the convenience of inline chaining.
    ///
    func forAutoLayout() -> Self {
        self.translatesAutoresizingMaskIntoConstraints = false
        return self
    }
}
