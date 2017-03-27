//
//  ViewController.swift
//  EmailActionSheet
//
//  Created by Harry Bloom on 22/03/2017.
//  Copyright © 2017 WeVat. All rights reserved.
//

import UIKit

class ViewController: UIViewController, ChooseEmailActionSheetPresenter {

    var chooseEmailActionSheet: UIAlertController?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        chooseEmailActionSheet = setupChooseEmailActionSheet()
    }
    
    @IBAction func showTapped(_ sender: Any) {
        show(chooseEmailActionSheet!, sender: self)
    }
}

