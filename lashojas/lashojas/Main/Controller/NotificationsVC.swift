//
//  NotificationsVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/18/21.
//

import UIKit

class NotificationsVC: BaseVC, FirebaseManagerDelegate {
    
    func onNotifications(_ item: [String : String]) {
        let id = item["id"]
        let chk = noti_arr.firstIndex { (noti) -> Bool in
            return noti["id"] == id
        }
        if chk == nil {
            noti_arr.append(item)
            tableView.reloadData()
        } else {
            noti_arr[chk!] = item
            tableView.reloadRows(at: [IndexPath(row: chk!, section: 0)], with: .automatic)
        }
    }
    

    @IBOutlet weak var tableView: UITableView!
    
    @IBAction func onMenu(_ sender: Any) {
        self.openMenu()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        firebaseManager.delegate = self
        loadData()
    }
    
    let firebaseManager = FirebaseManager()
    
    var noti_arr: [[String : String]] = []
    
    func loadData() {
        firebaseManager.observeNotifications()
    }

}

extension NotificationsVC: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.noti_arr.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NotificationCell", for: indexPath) as! NotificationCell
        cell.lbl_content.text = noti_arr[indexPath.row]["content"]
        cell.selectionStyle = .none
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        if let vc = self.storyboard?.instantiateViewController(identifier: "NotificationDetailVC") as? NotificationDetailVC {
            vc.title_str = noti_arr[indexPath.row]["content"] ?? ""
            vc.content_url = noti_arr[indexPath.row]["url"] ?? ""
            openVC(vc)
        }
        
    }
}

