//
//  ViewController.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/21/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var headerContentAlignment: UISegmentedControl!
    @IBOutlet weak var actionButtonsAlignment: UISegmentedControl!
    @IBOutlet weak var cancelConfirmationButtonAlignment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        headerContentAlignment.selectedSegmentIndex = 1
        actionButtonsAlignment.selectedSegmentIndex = 1
        cancelConfirmationButtonAlignment.selectedSegmentIndex = 1
    }

    @IBAction private func showActionSheetTapped(_ sender: UIButton) {
        let title = "What action would you like to take?"
//        let title = ""
        let message = "This is a message to provide a little more context."
//        let message = ""
        
        let actionController = ActionSheetController(title: title, message: message)
        actionController.headerContentAlignment = headerContentAlignment.selectedSegmentIndex == 0 ? .left : .center
        actionController.actionsContentAlignment = actionButtonsAlignment.selectedSegmentIndex == 0 ? .left : .center
        actionController.cancelConfirmationActionPosition = cancelConfirmationButtonAlignment.selectedSegmentIndex == 0 ? .left : .right
        
        for index in 1...12 {
            let testAction = Action(title: "Button Index: \(index)", style: .default) { _ in
                print("Test Action \(index) Tapped")
            }
            actionController.addAction(testAction)
        }
        
        let newSheetTitle = "Delete Something"
        let newSheetMessage = "Are you sure you want to delete something? This cannot be undone."
        let style: Action.Style = .hasConfirmation(newSheetTitle: newSheetTitle,
                                                   newSheetMessage: newSheetMessage,
                                                   confirmationActionTitle: "Delete")
        let deleteAction = Action(title: "Delete Something Now", style: style) { _ in
            print("Deleted Something")
        }
        
        actionController.addAction(deleteAction)
        presentActionSheet(actionController, animated: true)
    }
}
