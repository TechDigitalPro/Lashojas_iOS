//
//  ViewController.swift
//  lashojas
//
//  Created by Robin Hare on 2/15/21.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            self.appDelegate()?.goMain()
        }
    }


}

