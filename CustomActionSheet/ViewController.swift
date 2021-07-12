//
//  ViewController.swift
//  CustomActionSheet
//
//  Created by Raskin, Marlon on 6/21/21.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet private weak var actionLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
    }

    @IBAction private func showActionSheetTapped(_ sender: UIButton) {
        let title = "What action would you like to take?"
        let message = "This is a message to provide a little more context."
        
        let actionController = ActionSheetController(title: title, message: message)
        
        for index in 1...5 {
            let testAction = Action(title: "Button Index: \(index)", style: .default) { _ in
                print("Test Action \(index) Tapped")
            }
            actionController.addAction(testAction)
        }
        
        actionController.addAction(Action(title: "Cancel This", style: .cancel, actionHandler: { _ in
            print("Cancelled")
        }))

        presentActionSheet(actionController, animated: true)
    }
}
