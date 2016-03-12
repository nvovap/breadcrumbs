//
//  BCOptionsTableViewContoller.swift
//  Breadcrumbs
//
//  Created by nvovap on 3/11/16.
//  Copyright © 2016 nvovap. All rights reserved.
//

import UIKit

protocol BCOptionsTableViewContollerDelegate : class {
    func dismissWithUpdateOptions()
}

class BCOptionsTableViewContoller: UITableViewController {
    
    
    // MARK: - Outlet
    @IBOutlet weak var backgroundUpdateSwitch: UISwitch!
    @IBOutlet weak var backgroundLabel: UILabel!
    
    @IBOutlet weak var headingUpSwitch: UISwitch!
    @IBOutlet weak var headingUpLabel: UILabel!
    
    @IBOutlet weak var showTraficSwitch: UISwitch!
    @IBOutlet weak var showTraficLbel: UILabel!
    
    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var distanceSlider: UISlider!
    
    @IBOutlet weak var precisionLabel: UILabel!
    @IBOutlet weak var precisionSlider: UISlider!
    
    
    //Delegate property
    weak var delegate: BCOptionsTableViewContollerDelegate?
    
    
    // MARK: - Actions
    
    @IBAction func doBackgroundUpdateUpdateSwitch(sender: UISwitch) {
        print("\(__FUNCTION__)")
    }
    
    @IBAction func doHeadingUpUpdateSwitch(sender: UISwitch) {
         print("\(__FUNCTION__)")
    }
    
    
    @IBAction func doShowTraficUpdateSwitch(sender: UISwitch) {
         print("\(__FUNCTION__)")
    }
    
    
    @IBAction func doDistanceSliderChange(sender: UISlider) {
         print("\(__FUNCTION__)")
    }
    
    @IBAction func doGPSPrecisionSliderChange(sender: UISlider) {
         print("\(__FUNCTION__)")
        //precisionSlider.value
    }
    
    
    @IBAction func doDone(sender: AnyObject) {
        print("\(__FUNCTION__)")
        self.delegate?.dismissWithUpdateOptions()
    }
    
    @IBAction func doCancel(sender: AnyObject) {
        print("\(__FUNCTION__)")
        //self.delegate?.dismissWithUpdateOptions()
        
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    
}
