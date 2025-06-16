//
//  BoundingBox.swift
//  Common
//
//  Created by 전소영 on 2025/02/25.
//

import Foundation
import MapKit

struct BoundingBox {
    var minLatitude: CGFloat
    var maxLatitude: CGFloat
    var minLongitude: CGFloat
    var maxLongitude: CGFloat

    init(minLatitude: CGFloat, maxLatitude: CGFloat, minLongitude: CGFloat, maxLongitude: CGFloat) {
            self.minLatitude = minLatitude
            self.maxLatitude = maxLatitude
            self.minLongitude = minLongitude
            self.maxLongitude = maxLongitude
    }

    init(mapRect: MKMapRect) {
        let topLeft = mapRect.origin.coordinate
        let bottomRight = MKMapPoint(x: mapRect.maxX, y: mapRect.maxY).coordinate

        self.minLatitude = CGFloat(bottomRight.latitude)
        self.maxLatitude = CGFloat(topLeft.latitude)
        self.minLongitude = CGFloat(topLeft.longitude)
        self.maxLongitude = CGFloat(bottomRight.longitude)
    }

    func contains(coordinate: CLLocationCoordinate2D) -> Bool {
        let isContainedInX = minLatitude <= CGFloat(coordinate.latitude) && CGFloat(coordinate.latitude) <= maxLatitude
        let isContainedInY = minLongitude <= CGFloat(coordinate.longitude) && CGFloat(coordinate.longitude) <= maxLongitude

        return (isContainedInX && isContainedInY)
    }

    func intersects(boundingBox: BoundingBox) -> Bool {
        return (minLatitude <= boundingBox.maxLatitude && maxLatitude >= boundingBox.minLatitude &&
                minLongitude <= boundingBox.maxLongitude && maxLongitude >= boundingBox.minLongitude)
    }
}
