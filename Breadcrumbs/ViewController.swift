//
//  ViewController.swift
//  Breadcrumbs
//
//  Created by nvovap on 3/9/16.
//  Copyright © 2016 nvovap. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate, MKMapViewDelegate, BCOptionsTableViewContollerDelegate {

    /// The application state - "where we are in a known  sequence"
    enum AppState {
        case WaitingForViewDidLoad
        case RequestingAuth
        case LiveMapNoLogging
        case LiveMapLogging
        
        init() {
            self = .WaitingForViewDidLoad
        }
    }
    
    // The type of input (and its value) applied to the state machine
    enum AppStateInputSource {
        case None
        case Start
        case AuthorisationStatus(Bool)
        case UserWantsToStart(Bool)
    }
    
    
    // MARK: - Outlets
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var stopButton: UIBarButtonItem!
    @IBOutlet weak var clearButton: UIBarButtonItem!
    @IBOutlet weak var optionButton: UIBarButtonItem!
    
    
    // MARK: - Property
    lazy var locationManager: CLLocationManager = {
        let loc = CLLocationManager()
        
        //Set up location manager with defaults
        loc.desiredAccuracy =  kCLLocationAccuracyBest
        loc.distanceFilter = kCLDistanceFilterNone
        loc.delegate = self
        
        
        //Optimisation of battery
        loc.pausesLocationUpdatesAutomatically = true
        loc.activityType = CLActivityType.Fitness
        loc.allowsBackgroundLocationUpdates = false
        
        return loc
    }()
    
    //Application state
    private var state: AppState = AppState() {
        willSet {
            print("Changing from state \(state) to \(newValue)")
        }
        
        didSet {
            self.updateOutputWithSate()
        }
    }
    
    
    private var options: BCOptions = BCOptions() {
        didSet {
            options.updateDefaults()
            BCOptions.commit()
        }
    }
    
    // MARK: - View Controller Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // locationManager = CLLocationManager()
        
        self.updateStateWithInput(.Start)
        
    }

    
    
    // MARK: - CLLocationManagerDelegate
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        if status == CLAuthorizationStatus.AuthorizedAlways {
            self.updateStateWithInput(.AuthorisationStatus(true))
        } else {
            self.updateStateWithInput(.AuthorisationStatus(false))
        }
        
    }
    
    
    // MARK: Action and Events
    @IBAction func doSart(sender: AnyObject) {
        self.updateStateWithInput(.UserWantsToStart(true))
        
    }
    
    @IBAction func doStop(sender: AnyObject) {
        self.updateStateWithInput(.UserWantsToStart(false))
    }
    
    @IBAction func doClear(sender: AnyObject) {
        
    }
    
    @IBAction func doOption(sender: AnyObject) {
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "ModalOptions" {
            if let dstVC = segue.destinationViewController as? BCOptionsTableViewContoller {
                dstVC.delegate = self
            }
        }
    }
    
    
    // MARK: - BCOptionsTableViewContollerDelegate
    func dismissWithUpdateOptions(options: BCOptions?) {
        self.dismissViewControllerAnimated(true) { () -> Void in
            if let options = options {
                self.options = options
            }
        }
    }
    
    
    // MARK: State Machine
    //UPDATE STATE
    func updateStateWithInput(ip: AppStateInputSource) {
        
        var nextSate = self.state
        
        switch (self.state) {
        case .WaitingForViewDidLoad:
            if case .Start = ip {
                nextSate = .RequestingAuth
            }
        case .RequestingAuth:
            if case .AuthorisationStatus(let val) = ip where  val == true {
                nextSate = .LiveMapNoLogging
            }
        case .LiveMapNoLogging:
            //Check for usr cancelling permission
            if case .AuthorisationStatus(let val) = ip where val == false {
                nextSate = .RequestingAuth
            }
            
            //Check for start button
            else if case .UserWantsToStart(let val) = ip where val == true {
                nextSate = .LiveMapLogging
            }
            
        case .LiveMapLogging:
            //Check for usr cancelling permission
            if case .AuthorisationStatus(let val) = ip where val == false {
                nextSate = .RequestingAuth
            }
            //Check for start button
            else if case .UserWantsToStart(let val) = ip where val == false {
                nextSate = .LiveMapNoLogging
            }
        }
        
        self.state = nextSate
        updateOutputWithSate()
    }
    
    
    //UPDATE (MORE) OUTPUTS
    func updateOutputWithSate() {
        switch (self.state) {
        case .WaitingForViewDidLoad:
            break
        case .RequestingAuth:
            locationManager.requestAlwaysAuthorization()
            
            //Set UI into default state until authorised
            
            //Buttons
            startButton.enabled  = false
            stopButton.enabled   = false
            clearButton.enabled  = false
            optionButton.enabled = false
            
            //Map defaults (pedantic)
            mapView.delegate = nil
            mapView.showsUserLocation = false
            
            //Location maneger (pedantic)
            locationManager.stopUpdatingLocation()
            locationManager.allowsBackgroundLocationUpdates = false
            
        case .LiveMapNoLogging:
            
            //Buttons
            startButton.enabled  = true
            stopButton.enabled   = false
            clearButton.enabled  = false
            optionButton.enabled = true
            
            //Map defaults (pedantic)
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .Follow
            mapView.showsTraffic = true
            
        case .LiveMapLogging:
            //Buttons
            startButton.enabled  = false
            stopButton.enabled   = true
            clearButton.enabled  = false
            optionButton.enabled = true
            
            //Map defaults (pedantic)
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .Follow
            mapView.showsTraffic = true
            
            //Location maneger (pedantic)
        //    locationManager.startUpdatingLocation()
        //    locationManager.allowsBackgroundLocationUpdates = true
        }
    }

}

