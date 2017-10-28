//
//  BaseViewController.swift
//  hack4no
//
//  Created by Laureen Schausberger on 28.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import UIKit
import MapKit

class BaseViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        let textAttributes = [NSAttributedStringKey.foregroundColor:UIColor.white]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
}
