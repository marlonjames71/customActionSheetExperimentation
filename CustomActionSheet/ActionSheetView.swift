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
    
    // MARK: -  Properties
    
    weak var delegate: ActionSheetViewDelegate?
    
    var sheetTitle: String?
    var sheetMessage: String?
    
    private(set) var actionButtons: [UIButton] = []
    private(set) var cancelAction: UIButton = UIButton()
    
    var headerContentAlignment: NSTextAlignment = .center
    var actionsContentAlignment: NSTextAlignment = .center
    
    private lazy var container: UIView = {
        let container = UIView().forAutoLayout()
        container.backgroundColor = .clear
        container.curveCorners(radius: 20.0)
        return container
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackview = UIStackView().forAutoLayout()
        stackview.axis = .vertical
        stackview.distribution = .fill
        stackview.alignment = .fill
        stackview.spacing = 8.0
        return stackview
    }()
    
    private lazy var confirmationContentStackView: UIStackView = {
        let stackiew = UIStackView()
        
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
    
    private lazy var button: UIButton = {
        let button = UIButton()
        button.titleLabel?.textAlignment = actionsContentAlignment
        return button
    }()
    
    private lazy var contentStackViewContainer: UIView = {
        let view = UIView().forAutoLayout()
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView().forAutoLayout()
        scrollView.showsVerticalScrollIndicator = false
        scrollView.showsHorizontalScrollIndicator = false
        return scrollView
    }()
    
    
    // MARK: -  Layout & Configure
    
    public override func layoutSubviews() {
        contentStackView.addArrangedSubviews([titleLabel, messageLabel])
        contentStackView.addArrangedSubview(divider)
        contentStackView.addArrangedSubviews(actionButtons)
        contentStackView.addArrangedSubview(cancelAction)
        contentStackView.setCustomSpacing(16.0, after: titleLabel)
        contentStackView.setCustomSpacing(20.0, after: messageLabel)
    }
    
    public override func configure() {
        backgroundColor = .secondarySystemBackground
    }
    
    public override func layout() {
        layoutWithScrollView()
    }
    
    
    // MARK: -  Layout
    
    private func layoutWithScrollView() {
        let inset: CGFloat = 16.0
        // FIXME: Fix bottom inset changing when orientation changes.
        // When making the numbers different according to orientation, they're not getting respected.
        let bottomInset: CGFloat = traitCollection.verticalSizeClass == .compact ? 28.0 : 28.0
        let stackViewInsets = UIEdgeInsets(top: inset, left: inset, bottom: bottomInset, right: inset)
        
        scrollView.pin(to: self)
        contentStackView.pin(to: scrollView, withInsets: stackViewInsets)
        
        let scrollViewHeightConstraint = scrollView.heightAnchor.constraint(equalTo: contentStackView.heightAnchor,
                                                                            constant: bottomInset + inset)
        scrollViewHeightConstraint.priority = .defaultHigh
        
        NSLayoutConstraint.activate([
            scrollView.widthAnchor.constraint(equalTo: contentStackView.widthAnchor, constant: inset * 2),
            scrollViewHeightConstraint
        ])
    }
    
    private func layoutWithoutScrollView() {
        // Uncomment line 107 - add back in, the cancel action to the stackview
        // Can't add more than 2 or 3 actions or it elements get cut off
        // This is what I'm trying to solve with the scrollview
        contentStackView.pin(to: self, withInsets: .init(top: 16, left: 16, bottom: 32, right: 16))
    }
    
    
    // MARK: -  Methods
    
    func setActionButtons(_ buttons: [UIButton]) {
        actionButtons = buttons
    }
    
    func setCancelAction(_ button: UIButton) {
        cancelAction = button
    }
    
    @objc func toggleViews() {
        UIView.animate(withDuration: 0.2, delay: 0.0, options: [.curveEaseOut]) {
            self.contentStackView.arrangedSubviews[2].isHidden.toggle()
            self.contentStackView.arrangedSubviews[3].isHidden.toggle()
        }
        
        delegate?.setNeedsUpdatePresentationLayout()
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
