//
//  ProgrammaticUIViewController.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/22/21.
//

import UIKit

public class ProgrammaticUIViewController: UIViewController {
    
    public init() {
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public override func viewDidLoad() {
        configure()
    }
    
    public func configure() { }
}
