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

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func runAction() {
        guard let action = action else { return }
        action.actionHandler?(action)
    }
}
