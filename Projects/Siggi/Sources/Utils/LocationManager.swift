//
//  LocationManager.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/12.
//

import SwiftUI
import MapKit

@Observable final class LocationManager: NSObject, CLLocationManagerDelegate {
    private var location = CLLocation()
    private let locationManager = CLLocationManager()
    var position: MapCameraPosition = .automatic
    
    override init() {
        super.init()
        locationManager.delegate = self
    }
    
    func startCurrentLocationUpdates() async throws {
        if locationManager.authorizationStatus == .notDetermined {
            locationManager.requestWhenInUseAuthorization()
        }
        
        Task {
            do {
                for try await update in CLLocationUpdate.liveUpdates() {
                    guard let updatedLocation = update.location else { return }
                    self.location = updatedLocation
                    
                    if update.isStationary {
                        break
                    }
                    
                    let center = CLLocationCoordinate2D(
                        latitude: location.coordinate.latitude,
                        longitude: location.coordinate.longitude)
                    let region = MKCoordinateRegion(
                        center: center,
                        span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
                    position = MapCameraPosition.region(region)
                }
            } catch {
                print("Location Update Failed")
            }
        }
    }
}
