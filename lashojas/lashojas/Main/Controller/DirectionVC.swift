//
//  DirectionVC.swift
//  lashojas
//
//  Created by Robin Hare on 2/16/21.
//

import UIKit
import WebKit
import GoogleMaps

class DirectionVC: BaseVC {
    
    @IBOutlet weak var mapArea: UIView!
    @IBOutlet weak var seg_type: UISegmentedControl!
    
    @IBAction func onMenu(_ sender: Any) {
        self.openMenu()
    }
    
    @IBAction func onDirections(_ sender: Any) {
        let alertController = UIAlertController(title: "Abrir En Navegador", message: "Esto se abrirá en su navegador, ¿desea continuar?", preferredStyle: .alert)

            // Create the actions
        let okAction = UIAlertAction(title: "OK", style: .default) {_ in
            self.openDirectionPanel()
                
        }
        let cancelAction = UIAlertAction(title: "CANCELAR", style: .cancel)

        // Add the actions
        alertController.addAction(cancelAction)
        alertController.addAction(okAction)
        
        // Present the controller
        self.present(alertController, animated: true, completion: nil)
    }
    
    func openDirectionPanel() {
        if let url = URL(string: "http://maps.google.com/maps?saddr=\(MyLocation?.latitude ?? 0),\(MyLocation?.longitude ?? 0)&daddr=\(DirectionInfo["lat"] ?? "0"),\(DirectionInfo["long"] ?? "0")#bmb=1") {
            UIApplication.shared.open(url)
        }
    }
    
    var mapView: GMSMapView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        seg_type.addTarget(self, action: #selector(segmentedControlValueChanged), for: .valueChanged)
    }
    
    @objc func segmentedControlValueChanged(segment: UISegmentedControl) {
        if segment.selectedSegmentIndex == 0 {
            mapView.mapType = .normal
        } else {
            mapView.mapType = .satellite
        }
    }
    
    var is_mapview_loaded: Bool = false
    let default_zoom: Float = 8.0
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if !is_mapview_loaded {
            let camera = GMSCameraPosition.camera(withLatitude: MyLocation?.latitude ?? 0, longitude: MyLocation?.longitude ?? 0, zoom: default_zoom)
            mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
            mapView.frame = mapArea.frame
            mapView.frame.origin = CGPoint(x: 0, y: 0)
            mapArea.addSubview(mapView)
            mapView.mapType = .normal
            mapView.delegate = self
               
            mapView.isTrafficEnabled = false
            mapView.isMyLocationEnabled = false
            is_mapview_loaded = true
            
            setMarker()
            
            mapArea.bringSubviewToFront(seg_type)
        }
    }
    
    func setMarker() {
        let marker = GMSMarker()
        marker.title = DirectionInfo["name"]
        marker.snippet = DirectionInfo["address"]
        marker.icon = #imageLiteral(resourceName: "marker")
        marker.setIconSize(scaledToSize: .init(width: 30, height: 30))
        marker.position = CLLocationCoordinate2D(latitude: Double(DirectionInfo["lat"] ?? "0") ?? 0, longitude: Double(DirectionInfo["long"] ?? "0") ?? 0)
        marker.map = self.mapView
        
        let marker_1 = GMSMarker()
        marker_1.icon = #imageLiteral(resourceName: "currentPos")
        marker_1.setIconSize(scaledToSize: .init(width: 30, height: 30))
        if let location = MyLocation {
            marker_1.position = location
        }
        marker_1.map = self.mapView
    }
}

extension DirectionVC: GMSMapViewDelegate {
    func mapView(_ mapView: GMSMapView, didTap marker: GMSMarker) -> Bool {
        if marker.title ?? "" != "" {
            return false
        } else {
            return true
        }
    }
}

extension GMSMarker {
    func setIconSize(scaledToSize newSize: CGSize) {
        UIGraphicsBeginImageContextWithOptions(newSize, false, 0.0)
        icon?.draw(in: CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height))
        let newImage: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        icon = newImage
    }
}
