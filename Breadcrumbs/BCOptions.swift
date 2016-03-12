//
//  BCOptions.swift
//  Breadcrumbs
//
//  Created by nvovap on 3/12/16.
//  Copyright © 2016 nvovap. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

struct BCOptions {
    
    static let defaultsDictionary : [String : AnyObject] = {
        let fp = NSBundle.mainBundle().pathForResource("factoryDefaults", ofType: "plist")
        return NSDictionary(contentsOfFile: fp!) as! [String : AnyObject]
    }()
    
    
   static let defaults : NSUserDefaults = {
        let ud = NSUserDefaults.standardUserDefaults()
        ud.registerDefaults(BCOptions.defaultsDictionary)
        ud.synchronize()
        return ud
    }()

    lazy var backgroundUpdates: Bool = BCOptions.defaults.boolForKey("backgroundUpdate")
    lazy var headingAvailable:  Bool = CLLocationManager.headingAvailable()
    lazy var headingUp:   Bool       = self.headingAvailable && BCOptions.defaults.boolForKey("headingUp")
    lazy var showTraffic: Bool       = BCOptions.defaults.boolForKey("showTraffic")
    
    lazy var distanceBetweekMeasurements: Float  = BCOptions.defaults.floatForKey("distanceBetweekMeasurements")
    lazy var gpsPrecision: Float = BCOptions.defaults.floatForKey("gpsPrecision")
    
    var userTrackingMode: MKUserTrackingMode {
        mutating get {
            return self.headingUp ? .FollowWithHeading : .Follow
        }
    }
    
    mutating func updateDefaults() {
        BCOptions.defaults.setBool(backgroundUpdates, forKey: "backgroundUpdates")
        BCOptions.defaults.setBool(headingUp, forKey: "headingUp")
        BCOptions.defaults.setBool(showTraffic, forKey: "showTraffic")
        
        BCOptions.defaults.setFloat(distanceBetweekMeasurements, forKey: "distanceBetweekMeasurements")
        BCOptions.defaults.setFloat(gpsPrecision, forKey: "gpsPrecision")
    }
    
    static func commit() {
        BCOptions.defaults.synchronize()
    }
  
    
}
