//
//  LocationManager.swift
//  FaceMaskReminder
//
//  Created by Gabriela Coelho on 15/10/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import CoreLocation
import UserNotifications

protocol LocationAuthorization: class {
    func updateLocationAuthorization()
}

protocol NotificationAuthorization: class {
    func updateNotificationAuthorization()
    func newLocationReceived()
}

class DependenciesManager: NSObject, CLLocationManagerDelegate {
    
    private(set) var center: UNUserNotificationCenter?
    private(set) var locationManager: CLLocationManager?
    private(set) var geoCoder: CLGeocoder?

    weak var locationDelegate: LocationAuthorization?
    weak var notificationDelegate: NotificationAuthorization?
    
    override init() {
        super.init()
        center = UNUserNotificationCenter.current()
        locationManager = CLLocationManager()
        geoCoder = CLGeocoder()
    }
    
    func setup() {
        center?.requestAuthorization(options: [.alert, .sound]) { granted, error in
            self.notificationDelegate?.updateNotificationAuthorization()
        }
        
        locationManager?.distanceFilter = 50
        locationManager?.requestAlwaysAuthorization()
        locationManager?.delegate = self
    }
}

// MARK: - CLLocationManagerDelegate

extension DependenciesManager {
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.first else {
            return
        }
        
        geoCoder?.reverseGeocodeLocation(location) { placemarks, _ in
            self.notificationDelegate?.newLocationReceived()
//            if let place = placemarks?.first {
//                let newVisit = Visit(coordinates: location.coordinate, arrivalDate: Date(), departureDate: Date())
//            }
        }
    }

    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        locationDelegate?.updateLocationAuthorization()
    }
}
