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
    @IBOutlet weak var cancelButtonMatchAlignment: UISegmentedControl!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .secondarySystemBackground
        
        headerContentAlignment.selectedSegmentIndex = 0
        actionButtonsAlignment.selectedSegmentIndex = 0
        cancelConfirmationButtonAlignment.selectedSegmentIndex = 1
        cancelButtonMatchAlignment.selectedSegmentIndex = 1
    }

    @IBAction private func showActionSheetTapped(_ sender: UIButton) {
        let title = "Which Mac Pro would you like to buy?"
//        let title = ""
        let message = "You can checkout via  Apple Pay."
//        let message = ""
        
        let actionController = ActionSheetController(title: title, message: message)
        actionController.headerContentAlignment = headerContentAlignment.selectedSegmentIndex == 0 ? .left : .center
        actionController.actionsContentAlignment = actionButtonsAlignment.selectedSegmentIndex == 0 ? .left : .center
        actionController.cancelConfirmationActionPosition = cancelConfirmationButtonAlignment.selectedSegmentIndex == 0 ? .left : .right
        actionController.cancelButtonShouldMatchActionButtonsAlignment = cancelButtonMatchAlignment.selectedSegmentIndex == 0 ? true : false
        
//        for index in 1...2 {
//            let testAction = Action(title: "Button Index: \(index)",
//                                    style: .default,
//                                    image: UIImage(systemName: "macpro.gen3")) { _ in
//                print("Test Action \(index) Tapped")
//            }
//            actionController.addAction(testAction)
//        }

        
        let buyGen1Action = Action(title: "Buy Mac Pro Gen 1",
                                   style: .default,
                                   image: UIImage(systemName: "macpro.gen1")) { _ in
            print("...Buying Mac Pro gen 1")
        }
        
        let buyGen2Action = Action(title: "Buy Mac Pro Gen 2",
                                   style: .default,
                                   image: UIImage(systemName: "macpro.gen2")) { _ in
            print("...Buying Mac Pro gen 2")
        }
        
        let buyGen3Action = Action(title: "Buy Mac Pro Gen 3",
                                   style: .default,
                                   image: UIImage(systemName: "macpro.gen3")) { _ in
            print("...Buying Mac Pro gen 3")
        }

        let newSheetTitle = "Buy All Mac Pro Gens"
        let newSheetMessage = "Are you sure you want to buy all three Mac Pro gens? That's like $45,000."
        let buyAllStyle = Action.Style.hasConfirmation(newSheetTitle: newSheetTitle,
                                                       newSheetMessage: newSheetMessage,
                                                       confirmationActionTitle: "Buy All")
        let buyAllGens = Action(title: "Buy All Mac Pro Gens",
                                   style: buyAllStyle,
                                   image: UIImage(systemName: "bag")) { _ in
            print("...Buying all Mac Pro gens")
        }

        [buyGen1Action, buyGen2Action, buyGen3Action, buyAllGens].forEach { actionController.addAction($0) }
        presentActionSheet(actionController, animated: true)
    }
}
