//
//  ActionSheetController+MockController.swift
//  CustomActionSheet
//
//  Created by Marlon Raskin on 7/14/21.
//

import UIKit

extension ActionSheetController {

    /// Provides a mock action sheet controller to showcase the different variations an action sheet controller can have.
    ///
    /// This method is built for taking in the values of the segmented controls for demoing the abilities and variations
    /// of an action sheet controller. More may be added.
    ///
    /// - Parameters:
    ///     - headerAlignment: The text alignment for the header content.
    ///     - showHeaderContent: Determines if the header content should be shown.
    ///     - actionsAlignment: Determines the content alignment of the action buttons.
    ///     - cancelConfirmationPosition: - Determines the position of the cancel button
    ///     while the action sheet is displayed in a confirmations state.
    ///     - cancelMatchesActionAlignment: Determines whether the cancel button should
    ///     match the content alignment of the rest of the action buttons
    ///     - showIcons: Determines whether icons should be displayed alongside the action buttons
    ///
    static func makeMockActionSheetController(
        headerAlignment: NSTextAlignment,
        showHeaderContent: Bool,
        actionsAlignment: UIControl.ContentHorizontalAlignment,
        cancelConfirmationPosition: ActionSheetController.ConfirmationCancelButtonPosition,
        cancelMatchesActionAlignment: Bool,
        showIcons: Bool) -> ActionSheetController {
        
        let title = showHeaderContent ? "Which Mac Pro would you like to buy?" : ""
        let message = showHeaderContent ? "You can checkout via  Apple Pay." : ""

        let actionController = ActionSheetController(title: title, message: message)
        actionController.headerContentAlignment = headerAlignment
        actionController.actionsContentAlignment = actionsAlignment
        actionController.cancelConfirmationActionPosition = cancelConfirmationPosition
        actionController.cancelButtonShouldMatchActionButtonsAlignment = cancelMatchesActionAlignment
        actionController.cornerRadius = 6.0
        actionController.landscapeCornerRadius = 16.0

        let actions = Action.generateMockActions(showIcons: showIcons)
        actionController.addActions(actions)

        return actionController
    }
}
