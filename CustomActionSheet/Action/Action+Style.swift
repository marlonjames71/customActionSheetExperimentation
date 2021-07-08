//
//  Action+Style.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/30/21.
//

import Foundation

extension Action {
    
    /// Styles and functionality to apply to action buttons.
    public enum Style: Equatable {
        
        /// Default action style.
        ///
        /// When tapped, the `ActionSheetController` dismisses itself, then runs the action handler.
        case `default`
        
        /// Cancel action style.
        ///
        /// Cancel style actions work just like default style actions except cancel style actions get put at
        /// the bottom of the `ActionSheetController` below all other actions. Cancel style actions
        /// are automatically provided for confirmation actions.
        ///
        /// - Important: Only one cancel action is allowed to be added to an `ActionSheetController`.
        case cancel
        
        /// A default style action that has a confirmation action attached to it.
        ///
        /// When an action, whose style is `.hasConfirmation(...)`  is initially tapped,
        /// the handler is delayed from running and presents a confirmation dialogue instead, along with a cancel action.
        /// If the confirmation is tapped, the `ActionSheetController` dismisses itself, then runs the action handler.
        ///
        /// - Parameters:
        ///     - title: Updates the `ActionSheetController`'s title to better match the context for the confirmation.
        ///     - message: Updates the `ActionSheetController`'s message to better match the context for the confirmation.
        case hasConfirmation(title: String?, message: String?)
        
        /// Initially displays the the `ActionSheetController` in the confirmation style.
        case isConfirmation
    }
}
