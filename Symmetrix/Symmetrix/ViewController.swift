//
//  ViewController.swift
//  Symmetrix
//
//  Created by Nigel Barber on 27/01/2020.
//  Copyright © 2020 Mindbrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        view.clear()
    }
    @IBAction func tipButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        
        let items = ["2.0", "4.0", "6.0", "8.0"]
        let controller = ArrayChoiceTableViewController(items) { (name) in
            view.lineWidth = CGFloat((name as NSString).doubleValue)
        }
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        let presentationController = controller.presentationController as! UIPopoverPresentationController
        presentationController.delegate = self
        presentationController.barButtonItem = sender
        presentationController.permittedArrowDirections = [.down, .up]
        self.present(controller, animated: true)
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView, let image = view.getImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

