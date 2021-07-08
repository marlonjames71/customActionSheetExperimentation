//
//  Action.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/22/21.
//

import UIKit


/// An action that can be taken when the user taps a button in an action sheet.
///
/// You use this class to configure information about a single action, including the title to display in the button,
/// any styling information, and a handler to execute when the user taps the button. After creating an alert action
/// object, add it to an `ActionSheetController` object before displaying the corresponding action sheet to the user.
///
public class Action: NSObject, UIAccessibilityIdentification {
    
    public var accessibilityIdentifier: String?
    
    // MARK: -  Properties
    
    /// The title of an action's button.
    ///
    /// This property is set to the value you specified in the `init(title:style:actionHandler:)` method.
    ///
    private(set) var actionTitle: String?
    

    /// The style that is applied to the action's button.
    ///
    /// This property is set to the value you specified in the `init(title:style:actionHandler:)` method.
    ///
    private(set) var style: Action.Style = .default


    /// The block to execute when the user selects an action.
    ///
    /// This property is set to the value you specified in the `init(title:style:actionHandler:)` method.
    ///
    private(set) var actionHandler: ((Action) -> Void)?
    
    
    /// A Boolean value indicating whether the action is currently enabled.
    ///
    /// The default value of this property is true. Changing the value to false causes the action to appear dimmed in the resulting alert.
    /// When an action is disabled, taps on the corresponding button have no effect.
    ///
    public var isEnabled: Bool = true
    
    
    // MARK: -  Init
    
    /// Create and return an action with the specified title and behavior.
    ///
    /// - Parameters:
    ///     - title: The text to use for the button title.
    ///
    ///     - style: Additional styling information to apply to the button. Use the style information to convey the type of action that is performed
    ///     by the button. For a list of possible values, see the constants in `Action.Style`.
    ///
    ///     - actionHandler: A block to execute when the user selects the action. This block has no return value and takes the selected
    ///     action object as its only parameter. A block to execute when the user selects an action. If the action's style is `.hasConfirmation`,
    ///     the execution of the block will be delayed until the action is confirmed.
    ///
    public convenience init(title: String?, style: Action.Style = .default, actionHandler: ((Action) -> Void)? = nil) {
        self.init()
        self.actionTitle = title
        self.style = style
        self.actionHandler = actionHandler
        
        self.accessibilityIdentifier = actionTitle
    }
}
