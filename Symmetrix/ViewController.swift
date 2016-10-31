//
//  ViewController.swift
//  Symmetrix
//
//  Created by Nigel Barber on 31/10/2016.
//  Copyright © 2016 @mindbrix. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var canvasView: SymmetrixView?
    
    @IBAction func clearButtonTapped(item: UIBarButtonItem) {
        self.canvasView!.clear()
    }
    
    @IBAction func saveButtonTapped(item: UIBarButtonItem) {
        if let image = self.canvasView!.getImage() {
            UIImageWriteToSavedPhotosAlbum(image, nil, nil, nil)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

