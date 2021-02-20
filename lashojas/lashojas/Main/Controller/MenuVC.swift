//
//  MenuVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/15/21.
//

import UIKit

protocol MenuVCDelegate {
    func gotoPage(id: Int)
    func closeMenu()
}

class MenuVC: UIViewController {
    
    var delegate: MenuVCDelegate?
    
    @IBAction func onClose(_ sender: Any) {
        self.delegate?.closeMenu()
    }
    
    @IBAction func onHome(_ sender: Any) {
        self.delegate?.gotoPage(id: 1)
    }
    
    @IBAction func onBungal(_ sender: Any) {
        self.delegate?.gotoPage(id: 2)
    }
    @IBAction func onMap(_ sender: Any) {
        self.delegate?.gotoPage(id: 3)
    }
    
    @IBAction func onChat(_ sender: Any) {
        self.delegate?.gotoPage(id: 4)
    }
    
    @IBAction func onGallery(_ sender: Any) {
        self.delegate?.gotoPage(id: 5)
    }
    
    @IBAction func onFoodMenu(_ sender: Any) {
        self.delegate?.gotoPage(id: 6)
    }
    
    @IBAction func onDirection(_ sender: Any) {
        self.delegate?.gotoPage(id: 7)
    }
    
    @IBAction func onMembership(_ sender: Any) {
        self.delegate?.gotoPage(id: 8)
    }
    
    @IBAction func onNotification(_ sender: Any) {
        self.delegate?.gotoPage(id: 9)
    }
    
    @IBAction func onSettings(_ sender: Any) {
        self.delegate?.gotoPage(id: 10)
    }
    
}
