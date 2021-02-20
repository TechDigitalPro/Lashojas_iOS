//
//  UserDefaultsManager.swift
//  lashojas
//
//  Created by Robin Hare on 2/17/21.
//

import UIKit

class UserDefaultsManager: NSObject {
    static let shared = UserDefaultsManager()
    
    var locationServicesDisabled: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "LOCATION_SERVICES_DISABLED")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LOCATION_SERVICES_DISABLED")
        }
    }
    
    var globalAnnouncementsDisabled: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "GLOBAL_ANNOUNCEMENTS_DISABLED")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "GLOBAL_ANNOUNCEMENTS_DISABLED")
        }
    }
    
    var localAreaAnnouncements: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "LOCAL_AREA_ANNOUNCEMENTS")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LOCAL_AREA_ANNOUNCEMENTS")
        }
    }
    
    var locationBasedNotifications: Bool? {
        get {
            return UserDefaults.standard.bool(forKey: "LOCATION_BASED_NOTIFICATIONS")
        }
        set {
            UserDefaults.standard.set(newValue, forKey: "LOCATION_BASED_NOTIFICATIONS")
        }
    }
}
