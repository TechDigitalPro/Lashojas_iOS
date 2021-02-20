//
//  FirebaseManager.swift
//  lashojas
//
//  Created by Robin Hare on 2/18/21.
//

import Foundation
import Firebase
import FirebaseCore
import FirebaseDatabase

protocol FirebaseManagerDelegate {
    func onNotifications(_ item: [String : String])
}

class FirebaseManager: NSObject {
    
    var databaseRoot: DatabaseReference!
    var notificationDataRef: DatabaseReference!
    
    var delegate: FirebaseManagerDelegate?
    
    override init() {
        super.init()
        
        databaseRoot = Database.database().reference()
        notificationDataRef = databaseRoot.child("Notifications")
    }
    
    func observeNotifications() {
        notificationDataRef.queryLimited(toLast: 100).observe(.childAdded, with: { [weak self] snapshot in
            let id = String(snapshot.key)
            if let snpsht = snapshot.value as? NSDictionary {
                self?.delegate?.onNotifications([
                    "id": id,
                    "content": snpsht["content"] as? String ?? "",
                    "url": snpsht["url"] as? String ?? ""
                ])
            }
        })
    }
    
}

