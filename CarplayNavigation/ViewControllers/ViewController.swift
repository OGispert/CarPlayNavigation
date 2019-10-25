//
//  ViewController.swift
//  CarplayNavigation
//
//  Created by Gispert, Othmar on 10/24/19.
//  Copyright © 2019 Gispert, Othmar. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        ResultsManager.shared.fetchSearchResults()
    }
}

