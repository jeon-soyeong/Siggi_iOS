//
//  SiggiAnnotation.swift
//  Common
//
//  Created by 전소영 on 2025/02/25.
//

import Foundation
import MapKit

public final class SiggiAnnotation: NSObject, MKAnnotation, Identifiable {
    public var coordinate: CLLocationCoordinate2D
    public var title: String?
    public var titles: [String]?

    public init(coordinate: CLLocationCoordinate2D, title: String, titles: [String]) {
        self.coordinate = coordinate
        self.title = title
        self.titles = titles
    }
}
