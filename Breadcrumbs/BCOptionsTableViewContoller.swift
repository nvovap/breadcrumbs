//
//  BCOptionsTableViewContoller.swift
//  Breadcrumbs
//
//  Created by nvovap on 3/11/16.
//  Copyright © 2016 nvovap. All rights reserved.
//

import UIKit

protocol BCOptionsTableViewContollerDelegate : class {
    func dismissWithUpdateOptions(options: BCOptions?)
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
    
    
    //Local copy of the Options
    var options: BCOptions = BCOptions()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.updateUIWithState()
    }
    
    
    func updateUIWithState() {
        self.backgroundUpdateSwitch.on = self.options.backgroundUpdates
        
        if self.options.headingAvailable {
            self.headingUpSwitch.on = self.options.headingUp
            self.headingUpSwitch.enabled  = true
            self.headingUpLabel.alpha = 1.0
        } else {
            self.headingUpSwitch.on = false
            self.headingUpSwitch.enabled  = false
            self.headingUpLabel.alpha = 0.2
        }
        
        self.showTraficSwitch.on  = self.options.showTraffic
        
        self.distanceSlider.value = self.options.distanceBetweekMeasurements
        self.distanceLabel.text = "\(Int(self.options.distanceBetweekMeasurements)) m"
       
        self.precisionSlider.value = self.options.gpsPrecision
        self.precisionLabel.text = "\(Int(self.options.gpsPrecision)) m"
    }
    
    
    func updateStateFromUI() {
        
        self.options.backgroundUpdates = self.backgroundUpdateSwitch.on
        self.options.headingUp = self.headingUpSwitch.on
        self.options.showTraffic = self.showTraficSwitch.on
        self.options.distanceBetweekMeasurements = self.distanceSlider.value
        self.options.gpsPrecision = self.precisionSlider.value
        
    }
    
    // MARK: - Actions
    
    @IBAction func doBackgroundUpdateUpdateSwitch(sender: UISwitch) {
        self.updateStateFromUI()
        print("\(__FUNCTION__)")
    }
    
    @IBAction func doHeadingUpUpdateSwitch(sender: UISwitch) {
        self.updateStateFromUI()
         print("\(__FUNCTION__)")
    }
    
    
    @IBAction func doShowTraficUpdateSwitch(sender: UISwitch) {
        self.updateStateFromUI()
         print("\(__FUNCTION__)")
    }
    
    
    @IBAction func doDistanceSliderChange(sender: UISlider) {
        self.distanceLabel.text = "\(Int(self.distanceSlider.value)) m"
        
        self.updateStateFromUI()
         print("\(__FUNCTION__)")
    }
    
    @IBAction func doGPSPrecisionSliderChange(sender: UISlider) {
        
        self.precisionLabel.text = "\(Int(self.precisionSlider.value)) m"
        
        self.updateStateFromUI()
         print("\(__FUNCTION__)")
        //precisionSlider.value
    }
    
    
    @IBAction func doDone(sender: AnyObject) {
        print("\(__FUNCTION__)")
        self.delegate?.dismissWithUpdateOptions(self.options)
    }
    
    @IBAction func doCancel(sender: AnyObject) {
        print("\(__FUNCTION__)")
        self.delegate?.dismissWithUpdateOptions(nil)
        
    }
    
    
}
