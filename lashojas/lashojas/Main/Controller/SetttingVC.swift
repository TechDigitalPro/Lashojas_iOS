//
//  SetttingVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/17/21.
//

import UIKit
import CoreLocation

class SettingVC: BaseVC {
    
    @IBOutlet weak var g_announce_switch: UISwitch!
    @IBOutlet weak var l_announce_switch: UISwitch!
    @IBOutlet weak var notification_switch: UISwitch!
    @IBOutlet weak var lbl_location: UILabel!
    @IBOutlet weak var lbl_build_num: UILabel!
    @IBOutlet weak var btn_location_service: UIButton!
    
    @IBAction func onMenu(_ sender: Any) {
        self.openMenu()
    }
    
    @IBAction func onDisableLocation(_ sender: Any) {
        showAlert(title: "Warning", message: "Are you sure to change location services?") {
            self.userDefaults.locationServicesDisabled = self.userDefaults.locationServicesDisabled ?? false ? false : true
            self.setLocationBtn()
        }
    }
    
    func setLocationBtn() {
        if userDefaults.locationServicesDisabled ?? false {
            btn_location_service.setTitle("Enable Location Services", for: .normal)
        } else {
            btn_location_service.setTitle("Disable Location Services", for: .normal)
        }
    }
    
    @objc func onGlobalAnnouncements() {
        self.userDefaults.globalAnnouncementsDisabled = self.userDefaults.globalAnnouncementsDisabled ?? false ? false : true
    }
    
    @objc func onLocalAreaAnnouncements() {
        self.userDefaults.localAreaAnnouncements = self.userDefaults.localAreaAnnouncements ?? false ? false : true
    }
    
    @objc func onLocationBasedNotifications() {
        self.userDefaults.locationBasedNotifications = self.userDefaults.locationBasedNotifications ?? false ? false : true
    }
    
    let userDefaults = UserDefaultsManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setLocationBtn()
        g_announce_switch.isOn = !(userDefaults.globalAnnouncementsDisabled ?? false)
        l_announce_switch.isOn = !(userDefaults.localAreaAnnouncements ?? false)
        notification_switch.isOn = !(userDefaults.locationBasedNotifications ?? false)
        
        g_announce_switch.addTarget(self, action: #selector(onGlobalAnnouncements), for: .valueChanged)
        l_announce_switch.addTarget(self, action: #selector(onLocalAreaAnnouncements), for: .valueChanged)
        notification_switch.addTarget(self, action: #selector(onLocationBasedNotifications), for: .valueChanged)
        
        let appVersion = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String
        lbl_build_num.text = appVersion
        
        if let loc = MyLocation {
            let userLocation = CLLocation(latitude: loc.latitude, longitude: loc.longitude)
            let geocoder = CLGeocoder()
            geocoder.reverseGeocodeLocation(userLocation) { (placemarks, error) in
                if (error != nil){
                    print("error in reverseGeocode")
                }
                let placemark = placemarks! as [CLPlacemark]
                if placemark.count>0{
                    let placemark = placemarks![0]
                    print(placemark.locality != nil ? placemark.locality! : placemark.thoroughfare ?? "")
                    print(placemark.administrativeArea!)
                    print(placemark.country!)

                    self.lbl_location.text = "\(placemark.locality != nil ? (placemark.locality! + ", ") : "")\(placemark.administrativeArea!), \(placemark.country!)"
                }
            }
        }
    }
}
