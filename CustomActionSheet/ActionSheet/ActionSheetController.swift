//
//  ActionSheetViewController.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/21/21.
//

import UIKit



public class ActionSheetController: ProgrammaticUIViewController, CustomPresentable {
    
    public var transitionManager: UIViewControllerTransitioningDelegate?
    public var dismissalHandlingScrollview: UIScrollView?
    
    // MARK: -  Properties
    
    /// The view that is responsible for all of the UI layout and logic.
    private let actionSheetView = ActionSheetView()

    public typealias ConfirmationCancelButtonPosition = ActionSheetView.CancelActionPosition

    
    /// Set the corner radius of the action sheet view.
    ///
    /// The default is `8.0`.
    public var cornerRadius: CGFloat = 8.0
    

    /// The corner radius to be applied to the view of the action sheet while the phone is in the landscape orientation.
    ///
    /// A different corner radius may be desired when the actions sheet is presented and the phone is in the landscape orientation
    /// other than when in the portrait orientation. The action sheet will animate the radius of its corners when the phone transitions
    /// between screen orientations. If a corner radius value is not provided for the landscape orientation, the action sheet will
    /// use the `cornerRadius` property for both orientations.
    ///
    public var landscapeCornerRadius: CGFloat?
    

    /// Tells the actions sheet what alignment is to be used for the header content. The header content
    /// being the title and message.
    ///
    public var headerContentAlignment: NSTextAlignment = .center
    
    
    /// Tells the action sheet the horizontal alignment of the content (text and images) to be used for the action buttons.
    public var actionsContentAlignment: UIControl.ContentHorizontalAlignment = .center
    
    
    /// Tells the action sheet which position the cancel button should be placed when in a confirmation dialogues state.
    ///
    /// The position is set to `.right` by default. When the position is set to `.right`, the cancel button
    /// will be positioned to the right of the confirmation action button that gets placed at the bottom along with the cancel
    /// button when in a confirmation dialogue state. When set to `.left`, it gets placed to the left of the
    /// confirmation action button.
    ///
    public var cancelConfirmationActionPosition: ConfirmationCancelButtonPosition = ConfirmationCancelButtonPosition.defaultPosition
    
    
    /// The font used for the action buttons.
    public var actionsContentFont: UIFont = .systemFont(ofSize: 15)


    // FIXME: - See if this property is still needed or if it derives this value from the parent view controller
    public var supportsLandscape: Bool = true
    

    /// Tells the action sheet if the cancel button (when the sheet is in a default state) should take on the same
    /// horizontal content alignment as the rest of the action buttons.
    ///
    /// The default value is false, always placing the cancel button at the center of the action sheet on the x axis.
    ///
    public var cancelButtonShouldMatchActionButtonsAlignment = false


    /// The actions that the user can take in response to the action sheet.
    ///
    /// The actions are in the order in which you added them to the action sheet
    /// controller. This order also corresponds to the order in which they are displayed
    /// in the action sheet. The second action in the array is displayed below the first,
    /// the third is displayed below the second, and so on.
    ///
    private(set) var actions: [Action] = []

    public override func traitCollectionDidChange(_ previousTraitCollection: UITraitCollection?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
            self.actionSheetView.flashScrollIndicatorsOnAppear()
        }
        
        if let landscapeCornerRadius = landscapeCornerRadius {
            actionSheetView.cornerRadius = traitCollection.verticalSizeClass == .compact ? landscapeCornerRadius : cornerRadius          
        }
    }
    
    // MARK: -  Init
    
    public convenience init(title: String?, message: String?) {
        self.init()
        actionSheetView.delegate = self
        actionSheetView.sheetTitle = title
        actionSheetView.sheetMessage = message
        view = actionSheetView
    }
    
    
    // MARK: -  Lifecycle
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkHasValidNumberOfCancelActions()
        configureAndSetCancelActionButton()
        configureAndSetAllOtherActionButtons()
        actionSheetView.headerContentAlignment = headerContentAlignment
        actionSheetView.cancelConfirmationActionPosition = cancelConfirmationActionPosition
        actionSheetView.cornerRadius = cornerRadius
        actionSheetView.layoutSubviews()
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        actionSheetView.flashScrollIndicatorsOnAppear()
    }
    
    
    // MARK: -  Configure
    
    public override func configure() { }
    
    
    /// Generates an action button, first from one that might be provided to the action sheet controller. If one hasn't been
    /// provided, it generates one automatically and provides it to the action sheet view (UI) to be displayed.
    ///
    /// Cancel buttons are automatically placed at the bottom of an action sheet.
    ///
    private func configureAndSetCancelActionButton() {
        let cancelAction = getCancelAction(from: actions)
        let cancelButton = generateButtonFromAction(cancelAction)
        actionSheetView.setCancelAction(cancelButton)
    }
    
    
    /// Generates actions buttons from actions provided to the action sheet controller and
    /// provides them to the action sheet view (UI) to be displayed.
    ///
    private func configureAndSetAllOtherActionButtons() {
        let filteredActionButtons = generateActionButtons(from: filteredActions)
        actionSheetView.setActionButtons(filteredActionButtons)
    }
    
    
    // MARK: -  Controller Methods
    
    /// Checks if the action sheet controller has the valid number of actions.
    /// Out of the actions provided to an action sheet controller, only one of them
    /// is allowed to be ActionStyleCancel.
    ///
    private func checkHasValidNumberOfCancelActions() {
        let cancelActions = actions.filter { $0.style == .cancel }
        if cancelActions.count > 1 {
            fatalError("ActionSheetController can only have one action with a style of ActionStyleCancel")
        }
    }
    
    
    /// Attaches an action object to the action sheet.
    ///
    /// If your action sheet has multiple actions, the order in which you add those actions determines
    /// their order in the resulting action sheet.
    ///
    /// - Parameters:
    ///     - action: The action object to display as part of the action sheet. Actions are displayed as buttons in the action sheet.
    ///     The action object provides the button text and the action to be performed when that button is tapped.
    ///
    public func addAction(_ action: Action) {
        actions.append(action)
    }
    
    
    /// Attaches action objects to the action sheet.
    ///
    /// If your action sheet has multiple actions, the order in which you add those actions as arguments
    /// determines their order in the resulting action sheet.
    ///
    /// - Parameters:
    ///     - actions: A variadic parameter that takes action objects to display as part of the action sheet.
    ///     Actions are displayed as buttons in the action sheet. The action object provides the button text and
    ///     the action to be performed when that button is tapped.
    ///
    public func addActions(_ actions: Action...) {
        actions.forEach { addAction($0) }
    }
    
    
    /// Attaches action objects to the action sheet.
    ///
    /// If your action sheet has multiple actions, the order in which you add those actions as arguments
    /// determines their order in the resulting action sheet.
    ///
    /// - Parameters:
    ///     - actions: Takes an array of action objects to display as part of the action sheet.
    ///     Actions are displayed as buttons in the action sheet. The action object provides the button text and
    ///     the action to be performed when that button is tapped.
    ///
    public func addActions(_ actions: [Action]) {
        actions.forEach { addAction($0) }
    }
    
    
    // MARK: -  Helper Methods
    
    /// Actions not including cancel actions.
    ///
    private var filteredActions: [Action] {
        actions.filter { $0.style != .cancel }
    }
    
    
    /// Gets the first cancel action (if there is one) from the action sheet controller's actions array.
    /// If there isn't one, a cancel action is created automatically.
    ///
    /// Since a cancel action is created if one isn't provided, it's title will always remain "Cancel"
    /// Providing a cancel will allow control over the cancel button's title. For example, a better
    /// title in the context of a writing application might be "Keep Editing" instead of "Cancel".
    ///
    /// - Parameters:
    ///     - actions: The actions provided to the action sheet contoller.
    ///
    private func getCancelAction(from actions: [Action]) -> Action {
        let cancelAction = actions
            .lazy
            .first { $0.style == .cancel }
        
        if let cancelAction = cancelAction {
            return cancelAction
        } else {
            return Action(title: "Cancel", style: .cancel)
        }
    }
    
    
    /// Generates an `ActionButton` for each action created and added to the action sheet controller.
    ///
    /// - Parameters:
    ///     - actions: The actions added to the action sheet controller
    ///
    private func generateActionButtons(from actions: [Action]) -> [ActionButton] {
        actions.map { action in
            generateButtonFromAction(action)
        }
    }

    private func generateButtonFromAction(_ action: Action) -> ActionButton {
        let button = ActionButton(action: action,
                                  actionsContentAlignment: actionsContentAlignment,
                                  actionFont: actionsContentFont,
                                  cancelButtonMatchesNormalActionButtons: cancelButtonShouldMatchActionButtonsAlignment)
        
        button.addTarget(self, action: #selector(actionButtonPressed(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }
    
    /// Runs the action for the corresponding button, then dismisses the action sheet.
    ///
    /// If the action's style is `.hasConfirmation`, the action creates a confirmation action which is then
    /// displayed to the user in a confirmation style UI and the action to run is passed on to the newly created
    /// action inside a confirmation context.
    ///
    /// - Parameters:
    ///     - sender: The action button that was pressed
    ///
    @objc func actionButtonPressed(_ sender: ActionButton) {
        guard let action = sender.action else { return }
        switch action.style {
        case .hasConfirmation(let title, let message, let confirmationTitle):
            // This protects the user from a potentially bad UI/UX. A confirmation is important
            // enough to provide a secondary dialogue, therefore should have at leaat a title.
            let sanitizedTitle = title.replacingOccurrences(of: " ", with: "")
            guard sanitizedTitle.isEmpty == false else {
                fatalError("A confirmation title cannot be empty. A title must be provided.")
            }
            
            actionSheetView.confirmationAction = action
            
            let confirmationActionTitle = confirmationTitle ?? action.actionTitle
            let confirmationAction = Action(title: confirmationActionTitle,
                                            style: .isConfirmation,
                                            actionHandler: action.actionHandler)
            
            let confirmationButton = generateButtonFromAction(confirmationAction)
            
            actionSheetView.updateSheetForConfirmationState(newTitle: title,
                                                            newMessage: message,
                                                            confirmationButton: confirmationButton)
            actionSheetView.state = .confirmation
            
        /// Handles -> `.default`, `.cancel`, `.isConfirmation`
        default:
            sender.runAction()
            dismiss(animated: true, completion: nil)
        }
    }
}


// MARK: -  State

extension ActionSheetController {
    
    /// The state the action sheet is in.
    ///
    /// Usually each inital time an action sheet is presented, it's presented in a default state that provides options to
    /// choose from. An option, usually depending on it's importance or impact, may want further confirmation from a
    /// user before running its action. The state will then change to a confirmation state updating the UI where the user
    /// can then choose to go ahead with confirming the action or they can cancel.
    enum State: Int {
        
        /// The default state of an action sheet
        case `default`
        
        /// The confirmation state of an action sheet (usually reflected in the UI)
        case confirmation
    }
}


extension ActionSheetController: ActionSheetViewDelegate {
    // Provides important updates to the PresentationController. These may include
    // important UI updates like size changes.
    func setNeedsUpdatePresentationLayout() {
        updatePresentationLayout(animated: true)
    }
}


extension UIColor {
    static func fromHex(hex: Int32, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.init(red:     ((CGFloat)((hex & 0x00FF0000) >> 16) / 255.0),
                            green:   ((CGFloat)((hex & 0x0000FF00) >>  8) / 255.0),
                            blue:    ((CGFloat)((hex & 0x000000FF) >>  0) / 255.0),
                            alpha:   alpha)
    }
}
