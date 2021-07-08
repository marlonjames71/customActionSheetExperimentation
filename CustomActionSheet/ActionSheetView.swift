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
        let container = UIView()
        container.translatesAutoresizingMaskIntoConstraints = false
        container.backgroundColor = .clear
        container.curveCorners(radius: 20.0)
        return container
    }()
    
    private lazy var contentStackView: UIStackView = {
        let stackview = UIStackView()
        stackview.translatesAutoresizingMaskIntoConstraints = false
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
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 20.0, weight: .medium)
        label.numberOfLines = 0
        label.text = sheetTitle
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var messageLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = UIFont.systemFont(ofSize: 15.0)
        label.numberOfLines = 0
        label.text = sheetMessage
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var divider: UIView = {
        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
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
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    private lazy var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.alwaysBounceHorizontal = false
        scrollView.alwaysBounceVertical = true
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
        scrollView.resizeScrollViewContentSize()
    }
    
    public override func configure() {
        backgroundColor = .secondarySystemBackground
    }
    
    public override func layout() {
        layoutWithoutScrollView()
    }
    
    
    // MARK: -  Layout
    
    private func layoutWithScrollView() {
        // All the commented out code is stuff that I tried
        // When using this, comment out line 107 - don't add the cancelAction to the stackview
        
        addSubview(scrollView)
        addSubview(cancelAction)
        cancelAction.translatesAutoresizingMaskIntoConstraints = false
        
        contentStackViewContainer.pin(to: scrollView)
        contentStackViewContainer.addSubview(contentStackView)
        contentStackView.pin(to: contentStackViewContainer, withInsets: .init(top: 16, left: 16, bottom: 16, right: 16))
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: cancelAction.topAnchor, constant: -16),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            cancelAction.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 16),
            cancelAction.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -16),
            cancelAction.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -32),
        ])
//        scrollView.pin(to: self)
//        contentStackViewContainer.pin(to: scrollView)
//        contentStackView.pin(to: contentStackViewContainer, withInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 32.0, right: 16.0))
        
        scrollView.widthAnchor.constraint(equalTo: contentStackViewContainer.widthAnchor).isActive = true
        scrollView.heightAnchor.constraint(equalTo: contentStackViewContainer.heightAnchor).isActive = true
        cancelAction.setContentCompressionResistancePriority(.required, for: .vertical)

//        scrollView.addSubview(contentStackView)
//        contentStackView.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        
//        contentStackViewContainer.addSubview(titleLabel)
//        contentStackViewContainer.addSubview(contentStackView)
    
//        NSLayoutConstraint.activate([
//            contentStackView.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 16),
//            contentStackView.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor, constant: 16),
//            contentStackView.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor, constant: -16),
//            contentStackView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor, constant: -32),
//        ])
//        contentStackView.pin(to: self, withInsets: UIEdgeInsets(top: 16.0, left: 16.0, bottom: 32.0, right: 16.0))
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

// Got this from SO in hopes that it would take care of the sizing of the scrollview
extension UIScrollView {

    func resizeScrollViewContentSize() {
        var contentRect = CGRect.zero
        
        for view in self.subviews {
            contentRect = contentRect.union(view.frame)
        }
        
        self.contentSize = contentRect.size
    }
}
