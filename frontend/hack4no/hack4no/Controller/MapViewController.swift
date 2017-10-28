//
//  File.swift
//  hack4no
//
//  Created by Laureen Schausberger on 27.10.17.
//  Copyright © 2017 Laureen Schausberger. All rights reserved.
//

import Foundation
import UIKit

class MapViewController: BaseViewController {
    
    @IBOutlet weak var mapview: UIView!
    @IBOutlet weak var statisticsview: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hide(map: false, statistics: true)
    }
    
    @IBAction func changedView(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            self.hide(map: false, statistics: true)
            break
        case 1:
            self.hide(map: true, statistics: false)
            break
        default:
            break
        }
        
    }
    
    func hide(map: Bool, statistics: Bool) {
        self.mapview.isHidden = map
        self.statisticsview.isHidden = statistics
    }
    
}
