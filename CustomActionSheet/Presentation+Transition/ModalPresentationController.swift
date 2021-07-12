//
//  ModalPresentationController.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/22/21.
//

import UIKit

class ModalPresentationController: UIPresentationController {
    
    // MARK: -  Properties
    
    var tapGestureRecognizer: UITapGestureRecognizer = UITapGestureRecognizer()
    
    private lazy var backgroundView: UIView = {
        let view = UIView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    
    // MARK: -  Init
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(dismissActionSheetController))
        backgroundView.isUserInteractionEnabled = true
        backgroundView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    
    // MARK: -  Transitions
    
    override func presentationTransitionWillBegin() {
        guard let containerView = containerView else { return }
        backgroundView.alpha = 0.0
        containerView.insertSubview(backgroundView, at: 0)
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            backgroundView.alpha = 1.0
            return
        }
        
        coordinator.animate(alongsideTransition: { _ in
            self.backgroundView.alpha = 0.4
        })
    }
    
    override func dismissalTransitionWillBegin() {
        presentedViewController.transitionCoordinator?.animate(alongsideTransition: { [weak self] _ in
            self?.backgroundView.alpha = 0.0
        })
    }
    
    
    // MARK: -  Layout
    
    override var frameOfPresentedViewInContainerView: CGRect {
        guard let containerView = containerView,
              let presentedView = presentedView
        else { return .zero }
        // The below commented out property makes the view float when in landscape
        // Needs the view to round all corners
        // Needs the first vale in the `topSpacing` ternary operator to be 0.93 instead of 0.97
        //        let inset: CGFloat = traitCollection.verticalSizeClass == .compact ? 16 : 0
        let inset: CGFloat = 0
        let verticalInset = inset == 0 ? 0 : containerView.safeAreaInsets.bottom// + inset
        let width = min(containerView.bounds.width, containerView.bounds.height) - 2 * inset
        let targetWidth = width
        let fittingSize = CGSize(
            width: targetWidth,
            height: UIView.layoutFittingCompressedSize.height
        )
        var targetHeight = presentedView.systemLayoutSizeFitting(
            fittingSize,
            withHorizontalFittingPriority: .required,
            verticalFittingPriority: .defaultLow
        ).height
        let topSpacing: CGFloat = traitCollection.verticalSizeClass == .compact ? 0.97 : 0.8
        targetHeight = min(targetHeight, containerView.bounds.height * topSpacing)
        var frame = containerView.bounds
        frame.origin.x = frame.width / 2 - targetWidth / 2
        frame.origin.y += containerView.bounds.height - targetHeight - verticalInset
        frame.size.width = targetWidth
        frame.size.height = targetHeight
        return frame
    }
    
    override func containerViewWillLayoutSubviews() {
        super.containerViewWillLayoutSubviews()
        presentedView!.roundCornersWithMask(cornerRadius: 20.0, corners: [.topCorners])
        presentedView?.frame = frameOfPresentedViewInContainerView
        backgroundView.frame = containerView!.bounds
    }
    
    override func containerViewDidLayoutSubviews() {
        super.containerViewDidLayoutSubviews()
        
    }
    
    
    // MARK: -  Target Actions
    
    @objc private func dismissActionSheetController() {
        presentedViewController.dismiss(animated: true)
    }
}
