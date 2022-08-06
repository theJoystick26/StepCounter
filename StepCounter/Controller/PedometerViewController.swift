//
//  PedometerViewController.swift
//  StepCounter
//
//  Created by Adin Joyce on 7/31/22.
//

import UIKit
import RealmSwift
import MapKit

class PedometerViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var stepsLabel: UILabel!
    @IBOutlet weak var milesLabel: UILabel!
    @IBOutlet weak var startButton: UIButton!
    
    // initializing realm instance
    let realm = try! Realm()
    
    let hkManager = HKManager()
    // initializing tracker
    var tracker = Tracker()
    
    let locationManager = CLLocationManager()
    
    var oldLocation: CLLocation?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startButton.tintColor = UIColor.white
        startButton.backgroundColor = UIColor.green
        startButton.layer.cornerRadius = 0.5 * startButton.bounds.size.width
        startButton.clipsToBounds = true
        
        mapView.delegate = self
        tracker.delegate = self
        locationManager.delegate = self
        
        hkManager.authorizeHealthKit { success in
            if success {
                self.tracker.enableTracking()
                self.locationManager.configureLocationManager(sender: self)
            }
        }
        //        print("Realm is located at:", realm.configuration.fileURL!)
    }
    
    func centerMapOnLocation(_ location: CLLocation, mapView: MKMapView) {
        let regionRadius: CLLocationDistance = 500
        let coordinateRegion = MKCoordinateRegion(center: location.coordinate,
                                                  latitudinalMeters: regionRadius, longitudinalMeters: regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    @IBAction func buttonPressed(_ sender: UIButton) {
        if !tracker.getCountingStepsStatus() {
            tracker.startTrackingSteps()
            if let stopImage = UIImage(systemName: "stop.fill") {
                updateUI(UIColor.red, stopImage)
            }
        } else {
            tracker.stopTrackingSteps()
            if let playImage = UIImage(systemName: "play.fill") {
                updateUI(UIColor.green, playImage)
            }
            mapView.removeOverlays(mapView.overlays)
        }
    }
    
    // MARK: - Update UI Methods
    
    func updateUI(_ color: UIColor, _ buttonImage: UIImage) {
        startButton.backgroundColor = color
        startButton.setImage(buttonImage, for: .normal)
        self.stepsLabel.text = "Steps: 0"
        self.milesLabel.text = "Miles: 0"
    }
}

// MARK: - Tracker Delegate Methods

extension PedometerViewController: TrackerDelegate {
    func didUpdatePedometerData(_ steps: Int, _ miles: Float) {
        DispatchQueue.main.async {
            self.stepsLabel.text = "Steps: \(String(steps))"
            self.milesLabel.text = "Miles: \(miles.description)"
        }
    }
    
    func didFinishWalk(_ steps: Int, _ calories: Float, _ miles: Float, _ startTime: Date, _ endTime: Date) {
        let walk = Walk(steps, calories, miles, startTime, endTime)
        // Writing walk instance to realm
        do {
            try self.realm.write {
                self.realm.add(walk)
            }
        } catch {
            print("Error saving walk: \(error)")
        }
        // writing to HealthKit
        hkManager.writeToHealthKit(calories, startTime, endTime)
    }
    
    func didFailWithError(_ error: Error) {
        print(error)
    }
}

// MARK: - Extending CLLocationManager Methods

extension CLLocationManager{
    func configureLocationManager(sender: CLLocationManagerDelegate) {
        requestAlwaysAuthorization()
        requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            delegate = sender
            desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            startUpdatingLocation()
        }
    }
}

// MARK: - CLLocationManager Delegate Methods

extension PedometerViewController: CLLocationManagerDelegate {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let locaction: CLLocation = locations.last else { return }
        centerMapOnLocation(locaction, mapView: mapView)
        
        if tracker.getCountingStepsStatus() {
            if let oldLocation = oldLocation {
                let oldCoordinates = oldLocation.coordinate
                let newCoordinates = locaction.coordinate
                let area = [oldCoordinates, newCoordinates]
                let polyline = MKPolyline(coordinates: area, count: area.count)
                mapView.addOverlay(polyline)
            }
            
            oldLocation = locaction
        }
    }
}

// MARK: - MKMapView Delegate Methods

extension PedometerViewController: MKMapViewDelegate {
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if let overlay = overlay as? MKPolyline {
            let pr = MKPolylineRenderer(overlay: overlay)
            pr.strokeColor = UIColor.blue
            pr.lineWidth = 10
            return pr
        }
        return MKOverlayRenderer()
    }
}
