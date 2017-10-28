//
//  LightPollutionMapViewController.swift
//  hack4no
//
//  Created by Laureen Schausberger on 28.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation

class LightPollutionMapViewController: BaseMapController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setImage(#imageLiteral(resourceName: "map"))
        self.lights.alpha = 0.5
    }
}
