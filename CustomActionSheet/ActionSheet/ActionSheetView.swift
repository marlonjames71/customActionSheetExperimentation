//
//  ActionSheetView.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/22/21.
//

import UIKit

protocol ActionSheetViewDelegate: AnyObject {
    func setNeedsUpdatePresentationLayout()
}

public class ActionSheetView: ProgrammaticUIView {
    
    public enum CancelActionPosition {
        case right, left
        
        public static var defaultPosition: Self {
            .right
        }
    }
    
    // MARK: -  Properties
    
    weak var delegate: ActionSheetViewDelegate?
    
    var sheetTitle: String?
    var sheetMessage: String?
    
    private(set) var actionButtons: [UIButton] = []
    private(set) var cancelAction: UIButton = UIButton()
    
    var headerContentAlignment: NSTextAlignment = .center
    var actionsContentAlignment: NSTextAlignment = .center
    var cancelConfirmationActionPosition: CancelActionPosition = CancelActionPosition.defaultPosition
    
    var state: ActionSheetController.State = .default {
        didSet {
            updateSheetWithAnimation()
        }
    }
    var confirmationAction: Action?
    var confirmationButton: ActionButton?
    
    var cornerRadius: CGFloat = 0.0
    
    private lazy var contentStackView: UIStackView = {
        let stackview = UIStackView().forAutoLayout()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 8.0
        return stackview
    }()
    
    private lazy var confirmationContentStackView: UIStackView = {
        let stackiew = UIStackView().forAutoLayout()
        stackiew.axis = .horizontal
        stackiew.distribution = .fillEqually
        stackiew.alignment = .fill
        stackiew.spacing = 0.0
        return stackiew
    }()
    
    private lazy var titleLabel: UILabel = {
        let label = UILabel().forAutoLayout()
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.numberOfLines = 0
        label.text = sheetTitle
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel().forAutoLayout()
        label.setContentCompressionResistancePriority(.required, for: .vertical)
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        label.text = sheetMessage
        return label
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView().forAutoLayout()
        divider.backgroundColor = UIColor(red: 0.58, green: 0.58, blue: 0.60, alpha: 1.0)
        divider.heightAnchor.constraint(equalToConstant: 0.5).isActive = true
        divider.setContentCompressionResistancePriority(.required, for: .vertical)
        return divider
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView().forAutoLayout()
        scrollView.showsVerticalScrollIndicator = true
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    // MARK: -  Layout & Configure
    
    public override func layoutSubviews() {
        self.roundCornersWithMask(cornerRadius: cornerRadius, corners: [.topCorners])
        contentStackView.addArrangedSubviews([titleLabel, messageLabel])
        determineHeaderContentVisibility()
        contentStackView.addArrangedSubview(divider)
        determineDividerVisibility()
        contentStackView.addArrangedSubviews(actionButtons)
        addCancelActionAndDeterminePosition()
        contentStackView.addArrangedSubview(confirmationContentStackView)
        contentStackView.setCustomSpacing(16.0, after: titleLabel)
        contentStackView.setCustomSpacing(20.0, after: messageLabel)
        contentStackView.setCustomSpacing(20.0, after: divider)
        titleLabel.textAlignment = headerContentAlignment
        messageLabel.textAlignment = headerContentAlignment
        determineConfirmationActionAlignment()
    }
    
    public override func configure() {
        backgroundColor = .secondarySystemBackground
    }
    
    public override func layout() {
        layoutWithScrollView()
    }
    
    
    // MARK: -  Layout
    
    private func layoutWithScrollView() {
        let inset: CGFloat = 20.0
        // FIXME: Fix bottom inset changing when orientation changes.
        // When making the numbers different according to orientation, they're not getting respected.
        let bottomInset: CGFloat = traitCollection.verticalSizeClass == .compact ? 32.0 : 32.0
        let stackViewInsets = UIEdgeInsets(top: inset, left: inset, bottom: bottomInset, right: inset)
        
        scrollView.pin(to: self)
        contentStackView.pin(to: scrollView, withInsets: stackViewInsets)
        
        let scrollViewHeightConstraint = scrollView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor,
                                                                            constant: bottomInset + inset)
        scrollViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: inset * 2),
            scrollViewHeightConstraint,
        ])
    }
    
    
    // MARK: -  Methods
    
    func setActionButtons(_ buttons: [ActionButton]) {
        actionButtons = buttons
    }
    
    func setCancelAction(_ button: UIButton) {
        cancelAction = button
    }
    
    func flashScrollIndicatorsOnAppear() {
        scrollView.flashScrollIndicators()
    }
    
    func updateSheetForConfirmationState(newTitle: String,
                                         newMessage: String?,
                                         confirmationButton: ActionButton) {
        sheetTitle = newTitle
        sheetMessage = newMessage
        self.confirmationButton = confirmationButton
    }
    
    private func updateSheetWithAnimation() {
        for view in self.contentStackView.arrangedSubviews {
            if view is ActionButton {
                view.alpha = 0.0
                view.isHidden = true
            }
        }
        
        let titleAnimation = { self.titleLabel.text = self.sheetTitle }
        let messageAnimation = { self.messageLabel.text = self.sheetMessage }

        UIView.transition(with: titleLabel, duration: 0.12, options: [.transitionCrossDissolve], animations: titleAnimation)
        UIView.transition(with: messageLabel, duration: 0.12, options: [.transitionCrossDissolve], animations: messageAnimation)
        
        guard let confirmationButton = self.confirmationButton else { return }
        confirmationButton.alpha = 0.0
        confirmationButton.isHidden = true
        
        self.confirmationContentStackView.addArrangedSubview(confirmationButton)
        
        confirmationButton.alpha = 1.0
        confirmationButton.isHidden = false
        
        delegate?.setNeedsUpdatePresentationLayout()
    }

    private func determineHeaderContentVisibility() {
        [titleLabel, messageLabel].forEach {
            if let text = $0.text {
                $0.isHidden = text.isEmpty
                $0.alpha = text.isEmpty ? 0 : 1
            } else {
                $0.alpha = 0
            }
        }
    }
    
    private func determineDividerVisibility() {
        if let sheetTitle = sheetTitle,
           let sheetMessage = sheetMessage,
           sheetTitle.isEmpty && sheetMessage.isEmpty {
            divider.isHidden = true
            divider.alpha = 0
        } else {
            divider.isHidden = false
            divider.alpha = 1
        }
    }

    private func addCancelActionAndDeterminePosition() {
        if state == .default {
            confirmationContentStackView.addArrangedSubview(cancelAction)
        } else {
            let position = cancelConfirmationActionPosition == .left ? 0 : 1
            confirmationContentStackView.insertArrangedSubview(cancelAction, at: position)
        }
    }

    private func determineConfirmationActionAlignment() {
        if state == .confirmation {
            delegate?.setNeedsUpdatePresentationLayout()
            for button in confirmationContentStackView.arrangedSubviews {
                guard let button = button as? ActionButton else { continue }
                button.contentHorizontalAlignment = .center
            }
        }
    }
    
    private func format(message: String) -> NSMutableAttributedString {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 10
        paragraphStyle.alignment = .center
        
        let attrString = NSMutableAttributedString(string: message)
        attrString.addAttribute(.paragraphStyle, value:paragraphStyle, range:NSMakeRange(0, attrString.length))
        return attrString
    }
}
