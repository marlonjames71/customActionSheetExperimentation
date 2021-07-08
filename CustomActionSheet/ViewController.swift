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
        let actionController = ActionSheetController(title: "What Do You Want To Do?", message: "Any action you take cannot be undone, especially if it's destructive.")
        
        for index in 0...2 {
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
