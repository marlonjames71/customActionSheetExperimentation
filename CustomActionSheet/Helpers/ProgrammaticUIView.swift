//
//  ProgrammaticUIView.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/22/21.
//

import UIKit

open class ProgrammaticUIView: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        layout()
    }
    
    required public init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    /// Gets called at initialization
    public func configure() { }
    
    /// Gets called at initialization
    public func layout() { }
}
