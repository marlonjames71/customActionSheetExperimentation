//
//  ScaleOnPressButton.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/23/21.
//

import UIKit

class ActionButton: UIButton {
    
    var backgroundDefaultColor: UIColor?
    var backgroundHighlightColor: UIColor?
    var showHighlightedBackgroundOnPress = false
    var scaleTextOnlyOnPress = false
    
    var action: Action?

    override var isHighlighted: Bool {
        didSet {
            UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 1.0, initialSpringVelocity: 5.0, options: [.allowUserInteraction], animations: {
                if self.showHighlightedBackgroundOnPress {
                    self.backgroundColor = self.isHighlighted ? self.backgroundHighlightColor : self.backgroundDefaultColor
                }
                if self.scaleTextOnlyOnPress {
                    self.titleLabel?.transform = self.isHighlighted ? .init(scaleX: 0.98, y: 0.98) : .identity
                } else {
                    self.transform = self.isHighlighted ? .init(scaleX: 0.98, y: 0.98) : .identity
                }
            }, completion: nil)
        }
    }
    
    convenience init(action: Action,
                     actionsContentAlignment: UIControl.ContentHorizontalAlignment,
                     actionFont: UIFont,
                     cancelButtonMatchesNormalActionButtons: Bool) {
        self.init()
        
        self.action = action
        contentEdgeInsets = determineEdgeInsetsWith(alignment: actionsContentAlignment)
        showHighlightedBackgroundOnPress = true
        backgroundHighlightColor = .secondarySystemFill
        backgroundDefaultColor = .secondarySystemBackground
        titleLabel?.font = actionFont
        setTitle(action.actionTitle, for: .normal)
        tintColor = .label
        setTitleColor(.label, for: .normal)
        titleLabel?.numberOfLines = 1
        titleLabel?.lineBreakMode = .byTruncatingMiddle
        setImage(action.image, for: .normal)
        titleEdgeInsets = .init(top: .zero, left: action.image != nil ? 12.0 : 5.0, bottom: .zero, right: .zero)
        layer.cornerRadius = 6.0
        layer.cornerCurve = .continuous
        titleLabel?.font = action.style == .cancel ? .systemFont(ofSize: 16, weight: .medium) : .systemFont(ofSize: 16, weight: .regular)
        contentHorizontalAlignment = determineButtonAlignment(by: actionsContentAlignment,
                                                              and: cancelButtonMatchesNormalActionButtons,
                                                              with: action)
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func configure() {
        
    }
    
    func runAction() {
        guard let action = action else { return }
        action.actionHandler?(action)
    }
    
    private func determineEdgeInsetsWith(alignment: UIControl.ContentHorizontalAlignment) -> UIEdgeInsets {
        if alignment == .left {
            return .init(top: 5, left: 10, bottom: 5, right: 10)
        } else {
            return .zero
        }
    }
    
    private func determineButtonAlignment(by contentAlignment: UIControl.ContentHorizontalAlignment,
                                          and cancelButtonShouldMatchActionButtonsAlignment: Bool,
                                          with action: Action) -> UIControl.ContentHorizontalAlignment {
        if action.style == .cancel {
            return cancelButtonShouldMatchActionButtonsAlignment ? contentAlignment : .center
        } else {
            return contentAlignment
        }
    }
}
