//
//  ViewController.swift
//  Symmetrix
//
//  Created by Nigel Barber on 27/01/2020.
//  Copyright © 2020 Mindbrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    @IBAction func clearButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        view.clear()
    }
    @IBAction func tipButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView else { return }
        view.lineWidth = view.lineWidth == 2.0 ? 8.0 : 2.0
    }
    @IBAction func saveButtonTapped(_ sender: UIBarButtonItem) {
        guard let view = self.view as? SymmetrixView, let image = view.getImage() else { return }
        UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
}

