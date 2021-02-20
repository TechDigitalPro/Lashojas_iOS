//
//  HomeVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/15/21.
//

import UIKit
import CoreLocation

class HomeVC: BaseVC {
    
    @IBAction func onMenu(_ sender: Any) {
        self.openMenu()
    }
    
    @IBAction func onCall(_ sender: Any) {
        if let url = URL(string: "tel://\(PhoneNumber)") {
             UIApplication.shared.open(url)
        }
    }
    
    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.pageId = 1
        
        locationManager.requestAlwaysAuthorization()
        locationManager.requestWhenInUseAuthorization()
        locationManager.delegate = self
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.startUpdatingLocation()
        }
        
    }
}

extension HomeVC: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        MyLocation = manager.location?.coordinate
    }
}

