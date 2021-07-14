//
//  ActionSheetController+MockController.swift
//  CustomActionSheet
//
//  Created by Marlon Raskin on 7/14/21.
//

import UIKit

extension ActionSheetController {

    /// Provides a mock action sheet controller to showcase the different variations an action sheet controller can have.
    static func makeActionSheetController(
        headerAlignment: NSTextAlignment,
        showHeaderContent: Bool,
        actionsAlignment: UIControl.ContentHorizontalAlignment,
        cancelConfirmationPosition: ActionSheetController.ConfirmationPosition,
        cancelMatchesActionAlignment: Bool,
        showIcons: Bool) -> ActionSheetController {
        
        let title = showHeaderContent ? "Which Mac Pro would you like to buy?" : ""
        let message = showHeaderContent ? "You can checkout via  Apple Pay." : ""

        let actionController = ActionSheetController(title: title, message: message)
        actionController.headerContentAlignment = headerAlignment
        actionController.actionsContentAlignment = actionsAlignment
        actionController.cancelConfirmationActionPosition = cancelConfirmationPosition
        actionController.cancelButtonShouldMatchActionButtonsAlignment = cancelMatchesActionAlignment

        let gen1Image = showIcons ? UIImage(systemName: "macpro.gen1") : nil
        let gen2Image = showIcons ? UIImage(systemName: "macpro.gen2") : nil
        let gen3Image = showIcons ? UIImage(systemName: "macpro.gen3") : nil
        let allGensImage = showIcons ? UIImage(systemName: "bag") : nil

        let buyGen1Action = Action(title: "Buy Mac Pro Gen 1", style: .default, image: gen1Image) { _ in
            print("...Buying Mac Pro gen 1")
        }

        let buyGen2Action = Action(title: "Buy Mac Pro Gen 2", style: .default, image: gen2Image) { _ in
            print("...Buying Mac Pro gen 2")
        }

        let buyGen3Action = Action(title: "Buy Mac Pro Gen 3", style: .default, image: gen3Image) { _ in
            print("...Buying Mac Pro gen 3")
        }

        let newSheetTitle = "Buy All Mac Pro Gens"
        let newSheetMessage = "Are you sure you want to buy all three Mac Pro gens? That's like $45,000."
        let buyAllStyle = Action.Style.hasConfirmation(newSheetTitle: newSheetTitle,
                                                       newSheetMessage: newSheetMessage,
                                                       confirmationActionTitle: "Buy All")
        let buyAllGens = Action(title: "Buy All Mac Pro Gens", style: buyAllStyle, image: allGensImage) { _ in
            print("...Buying all Mac Pro gens")
        }

        [buyGen1Action, buyGen2Action, buyGen3Action, buyAllGens].forEach { actionController.addAction($0) }

        return actionController
    }
}
