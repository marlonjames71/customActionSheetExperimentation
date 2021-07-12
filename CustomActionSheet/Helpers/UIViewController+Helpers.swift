//
//  UIViewController+Helpers.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/21/21.
//

import UIKit

extension UIViewController: UIViewControllerTransitioningDelegate {
    public func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        ModalPresentationController(presentedViewController: presented, presenting: presenting)
    }
    
    
    /// Presents an `ActionSheetController` modally
    ///
    /// - Parameters:
    ///     - actionSheetControllerToPresent: The action sheet controller to present over the current view controller's content.
    ///     - flag: Pass `true` to animate the presentation; otherwise, pass `false`.
    ///     - completion:The block to execute after the presentation finishes. This block has no return value and takes no parameters. You may specify `nil` for this parameter.
    ///
    public func presentActionSheet(_ actionSheetControllerToPresent: ActionSheetController, animated flag: Bool, completion: (() -> Void)? = nil) {
        actionSheetControllerToPresent.modalPresentationStyle = .custom
        actionSheetControllerToPresent.transitioningDelegate = self
        present(actionSheetControllerToPresent, animated: flag, completion: completion)
    }
}
