//
//  ViewController.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/21/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headerContentAlignment: UISegmentedControl!
    @IBOutlet weak var showHeaderContent: UISegmentedControl!
    @IBOutlet weak var actionButtonsAlignment: UISegmentedControl!
    @IBOutlet weak var cancelConfirmationButtonAlignment: UISegmentedControl!
    @IBOutlet weak var cancelButtonMatchAlignment: UISegmentedControl!
    @IBOutlet weak var showIcons: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        headerContentAlignment.selectedSegmentIndex = 0
        showHeaderContent.selectedSegmentIndex = 0
        actionButtonsAlignment.selectedSegmentIndex = 0
        cancelConfirmationButtonAlignment.selectedSegmentIndex = 1
        cancelButtonMatchAlignment.selectedSegmentIndex = 1
        showIcons.selectedSegmentIndex = 1
    }

    @IBAction private func showActionSheetTapped(_ sender: UIButton) {
        let actionController = ActionSheetController.makeActionSheetController(
            headerAlignment: headerContentAlignment.selectedSegmentIndex == 0 ? .left : .center,
            showHeaderContent: showHeaderContent.selectedSegmentIndex == 0 ? true : false,
            actionsAlignment: actionButtonsAlignment.selectedSegmentIndex == 0 ? .left : .center,
            cancelConfirmationPosition: cancelConfirmationButtonAlignment.selectedSegmentIndex == 0 ? .left : .right,
            cancelMatchesActionAlignment: cancelButtonMatchAlignment.selectedSegmentIndex == 0 ? true : false,
            showIcons: showIcons.selectedSegmentIndex == 0 ? true : false
        )
        presentActionSheet(actionController, animated: true)
    }
}
