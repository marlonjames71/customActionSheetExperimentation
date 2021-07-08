//
//  ActionSheetViewController.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/21/21.
//

import UIKit



public class ActionSheetController: ProgrammaticUIViewController, CustomPresentable {
    
    var transitionManager: UIViewControllerTransitioningDelegate?
    var dismissalHandlingScrollview: UIScrollView?
    
    // MARK: -  Properties
    
    private let actionSheetView = ActionSheetView()
    
    private var state: State = .default
    
    public var actionSheetConfirmationTitle: String?
    public var actionSheetTitle: String?
    public var actionSheetMessage: String?
    public var tintColor: UIColor?
    public var cornerRadius: CGFloat?
    public var actionsContentAlignment: ActionsContentAlignment = .center
    public var actionsContentFont: UIFont = .systemFont(ofSize: 15)
    public var supportsLandscape: Bool = true
    
    private(set) var actions: [Action] = []

    
    // MARK: -  Init
    
    public convenience init(title: String?, message: String?) {
        self.init()
        actionSheetView.delegate = self
        actionSheetTitle = title
        actionSheetMessage = message
        actionSheetView.sheetTitle = title
        actionSheetView.sheetMessage = message
        view = actionSheetView
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        checkHasValidNumberOfCancelActions()
        configureAndSetCancelActionButton()
        configureAndSetAllOtherActionButtons()
        actionSheetView.layoutSubviews()
    }
    
    
    // MARK: -  Configure
    
    public override func configure() { }
    
    private func configureAndSetCancelActionButton() {
        let cancelAction = getCancelAction(from: actions)
        let cancelButton = generateButtonFromAction(cancelAction)
        actionSheetView.setCancelAction(cancelButton)
    }
    
    private func configureAndSetAllOtherActionButtons() {
        let filteredActionButtons = generateActionButtons(from: filteredActions)
        actionSheetView.setActionButtons(filteredActionButtons)
    }
    
    
    // MARK: -  Controller Methods
    
    private func checkHasValidNumberOfCancelActions() {
        let cancelActions = actions.filter { $0.style == .cancel }
        if cancelActions.count > 1 {
            fatalError("ActionSheetController can only have one action with a style of ActionStyleCancel")
        }
    }
    
    public func addAction(_ action: Action) {
        actions.append(action)
    }
    
    
    // MARK: -  Helper Methods
    
    private var filteredActions: [Action] {
        actions.filter { $0.style != .cancel }
    }
    
    private func getCancelAction(from actions: [Action]) -> Action {
        let cancelAction = actions
            .lazy
            .first { $0.style == .cancel }
        
        if let cancelAction = cancelAction {
            return cancelAction
        } else {
            return Action(title: "Cancel", style: .cancel) { _ in
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    private func generateActionButtons(from actions: [Action]) -> [UIButton] {
        actions.map { action in
            generateButtonFromAction(action)
        }
    }
    
    private func generateButtonFromAction(_ action: Action) -> ScaleOnPressButton {
        let button = ScaleOnPressButton()
        button.showHighlightedBackgroundOnPress = true
//        button.backgroundHighlightColor = UIColor.fromHex(hex: 0x2b2b2b)
        button.backgroundHighlightColor = .secondarySystemFill
        button.backgroundDefaultColor = .secondarySystemBackground
        button.titleLabel?.font = actionsContentFont
        button.setTitle(action.actionTitle, for: .normal)
        button.setTitleColor(.label, for: .normal)
        button.layer.cornerRadius = 6.0
        button.layer.cornerCurve = .continuous
        button.action = action
        button.addTarget(self, action: #selector(actionButtonPressed(_:)), for: .touchUpInside)
        button.heightAnchor.constraint(equalToConstant: 48).isActive = true
        return button
    }
    
    @objc func actionButtonPressed(_ sender: ScaleOnPressButton) {
        sender.runAction()
        dismiss(animated: true, completion: nil)
    }
}


// MARK: -  Content Alignment

extension ActionSheetController {
    
    /// Applies a specified alignment to all action buttons title and image (if provided)
    /// inside an `ActionSheetController` except cancel actions.
    ///
    public enum ActionsContentAlignment: Int {
        
        /// Applies left alignment to the action button's title
        case left   = 0
        
        /// Applies center alignmemt to the action button's title
        case center = 1
        
        /// Applies right alignment to that action button's title
        case right  = 2
    }
}


// MARK: -  State

extension ActionSheetController {
    enum State: Int {
        case `default`
        case confirmation
    }
}


extension ActionSheetController: ActionSheetViewDelegate {
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
