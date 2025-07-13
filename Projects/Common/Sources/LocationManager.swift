//
//  LocationManager.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/12.
//

import MapKit
import SwiftUI

@Observable public final class LocationManager: NSObject, CLLocationManagerDelegate {
    public var region: MKCoordinateRegion = MKCoordinateRegion()
    private var authorizationStatus: CLAuthorizationStatus = .notDetermined
    private var locationManager: CLLocationManager

    override public init() {
        self.locationManager = CLLocationManager()
        super.init()
        self.locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        self.authorizationStatus = locationManager.authorizationStatus
    }

    private func startUpdatingLocation() {
        if authorizationStatus == .authorizedWhenInUse || authorizationStatus == .authorizedAlways {
            locationManager.startUpdatingLocation()
        }
    }

    public func requestLocationAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }

    public func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    public func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        self.authorizationStatus = manager.authorizationStatus

        switch manager.authorizationStatus {
        case .authorizedWhenInUse, .authorizedAlways:
            startUpdatingLocation()
        case .denied, .restricted:
            print("위치 서비스가 거부되었거나 제한되었습니다.")
            stopUpdatingLocation()
        case .notDetermined:
            break
        @unknown default:
            break
        }
    }

    public func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        locations.last.map {
            region = MKCoordinateRegion(center: $0.coordinate,
                                        span: MKCoordinateSpan(latitudeDelta: 0.05,
                                                               longitudeDelta: 0.05))
        }
    }

    public func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        stopUpdatingLocation()
        print("locationManager error: \(error.localizedDescription)")
    }
}
