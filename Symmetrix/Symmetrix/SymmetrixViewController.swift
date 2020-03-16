//
//  ViewController.swift
//  Symmetrix
//
//  Created by Nigel Barber on 27/01/2020.
//  Copyright © 2020 Mindbrix. All rights reserved.
//

import UIKit

class SymmetrixViewController: UIViewController, UIPopoverPresentationControllerDelegate {
    // MARK: - Main.storyboard
    
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        view.clear()
    }
    @IBAction func colorButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        
        let items:[UIColor] = [UIColor.black, UIColor.red, UIColor.green, UIColor.blue]
        let controller = ArrayChoiceTableViewController(items, header: "Line color", labels: { value in "" }) { value in
            view.lineColor = value
        }
        presentPopover(controller, sender: sender)
    }
    @IBAction func tipButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        
        let items:[CGFloat] = [2.0, 4.0, 8.0, 16.0]
        let controller = ArrayChoiceTableViewController(items, header: "Line width", labels: { "\($0)" + ($0 == view.lineWidth ? "*" : "") }) { (value) in
            view.lineWidth = value
        }
        presentPopover(controller, sender: sender)
    }
    @IBAction func turnButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        
        let items:[Int] = [4, 8, 16, 32 ]
        let controller = ArrayChoiceTableViewController(items, header: "Symmetry", labels: { "\($0)" + ($0 == view.turns ? "*" : "") }) { (value) in
            view.turns = value
        }
        presentPopover(controller, sender: sender)
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView, let image = view.getImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    
    // MARK: - Utility
    
    func presentPopover(_ controller: UIViewController, sender: UIBarButtonItem) {
        self.dismiss(animated: false)
        controller.modalPresentationStyle = .popover
        controller.preferredContentSize = CGSize(width: 300, height: 200)
        if let presentationController = controller.popoverPresentationController {
            presentationController.delegate = self
            presentationController.barButtonItem = sender
            presentationController.permittedArrowDirections = [.down, .up]
        }
        self.present(controller, animated: true)
    }
    
    // MARK: - UIPopoverPresentationControllerDelegate
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
}

