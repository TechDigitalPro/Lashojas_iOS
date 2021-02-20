//
//  BaseVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/15/21.
//

import UIKit
import SideMenu

class BaseVC: UIViewController {
    
    var menuVC: MenuVC!
    
    func openMenu() {
        let menu = SideMenuNavigationController(rootViewController: menuVC)
        menu.menuWidth = 300
        menu.leftSide = true
        menu.statusBarEndAlpha = 0
        menu.presentationStyle = .menuSlideIn
        menu.presentationStyle.presentingEndAlpha = 0.5
        menu.navigationBar.isHidden = true
        self.present(menu, animated: true, completion: nil)
    }
    
    var pageId: Int = 1
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuVC") as? MenuVC {
            vc.delegate = self
            self.menuVC = vc
        }
    }
    
    func openHomeVC() {
        if let vc = self.storyboard?.instantiateViewController(identifier: "HomeVC") as? HomeVC {
            vc.pageId = 1
            openVC(vc)
        }
    }
    
    func openWebVC(_ id: Int, _ caption: String, _ url: String) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "WebVC") as? WebVC {
            vc.titleStr = caption
            vc.urlStr = url
            vc.pageId = id
            
            openVC(vc)
        }
    }
    
    func openDirectionVC(_ id: Int) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "DirectionVC") as? DirectionVC {
            vc.pageId = id
            
            openVC(vc)
        }
    }
    
    func openVC(_ vc: UIViewController) {
        vc.modalPresentationStyle = .fullScreen
        
        let transition = CATransition()
        transition.duration = 0.5
        transition.type = CATransitionType.push
        transition.subtype = CATransitionSubtype.fromRight
        transition.timingFunction = CAMediaTimingFunction(name:CAMediaTimingFunctionName.easeInEaseOut)
        view.window!.layer.add(transition, forKey: kCATransition)
        
        self.present(vc, animated: true)
    }
    
    func openNotificationVC(_ id: Int) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "NotificationsVC") as? NotificationsVC {
            vc.pageId = id
            
            openVC(vc)
        }
    }
    
    func openSettingVC(_ id: Int) {
        if let vc = self.storyboard?.instantiateViewController(identifier: "SettingVC") as? SettingVC {
            vc.pageId = id
            
            openVC(vc)
        }
    }
    
}

extension BaseVC: MenuVCDelegate {
    
    func gotoPage(id: Int) {
        self.dismiss(animated: true) {
            if self.pageId != id {
                switch id {
                case 1:
                    self.openHomeVC()
                    break
                case 2:
                    self.openWebVC(2, "Bungalows", BungalUrl)
                    break
                case 3:
                    self.openWebVC(3, "Mapa", MapUrl)
                    break
                case 4:
                    self.openWebVC(4, "Chat", ChatUrl)
                    break
                case 5:
                    self.openWebVC(4, "Galería", GalleryUrl)
                    break
                case 6:
                    self.openWebVC(6, "Menú", FoodMenuUrl)
                    break
                case 7:
                    self.openDirectionVC(7)
                    break
                case 8:
                    self.openWebVC(8, "Membresía", MembershipUrl)
                    break
                case 9:
                    self.openNotificationVC(9)
                    break
                case 10:
                    self.openSettingVC(10)
                    break
                default:
                    break
                }
            }
        }
    }
    
    func closeMenu() {
        self.dismiss(animated: true, completion: nil)
    }
    
}

