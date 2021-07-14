//
//  CustomPresentable.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 7/3/21.
//

import UIKit

public protocol CustomPresentable: UIViewController {
    var transitionManager: UIViewControllerTransitioningDelegate? { get set }
    var dismissalHandlingScrollview: UIScrollView? { get }
    func updatePresentationLayout(animated: Bool)
}

extension CustomPresentable {
    var dismissalHandlingScrollView: UIScrollView? { nil }
    
    public func updatePresentationLayout(animated: Bool = false) {
        presentationController?.containerView?.setNeedsLayout()
        if animated {
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.8, initialSpringVelocity: 0.4, options: .allowUserInteraction, animations: {
                self.presentationController?.containerView?.layoutIfNeeded()
            }, completion: nil)
        } else {
            presentationController?.containerView?.layoutIfNeeded()
        }
    }
}
