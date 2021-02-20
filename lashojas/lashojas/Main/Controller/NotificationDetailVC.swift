//
//  NotificationDetailVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/18/21.
//

import UIKit
import Kingfisher

class NotificationDetailVC: BaseVC {

    @IBOutlet weak var lbl_title: UILabel!
    @IBOutlet weak var img_content: UIImageView!
    
    @IBAction func onMenu(_ sender: Any) {
        self.openMenu()
    }
    
    var title_str: String = ""
    var content_url: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.lbl_title.text = title_str
        
        if let url = URL(string: content_url) {
            self.img_content.kf.setImage(with: url)
        }
    }
    
}
