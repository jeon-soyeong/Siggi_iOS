//
//  PlaceRecord.swift
//  Siggi
//
//  Created by 전소영 on 2024/11/21.
//

import Foundation
import SwiftData

@Model
public final class PlaceRecord {
    var name: String
    var date: Date
    var latitude: Double
    var longitude: Double
    var rating: Int = 0
    @Attribute(.externalStorage) var imageData: [Data]?
    var text: String?

    init(name: String, latitude: Double, longitude: Double, rating: Int = 0, imageData: [Data]? = nil, text: String? = nil, date: Date = .now) {
        self.name = name
        self.date = date
        self.latitude = latitude
        self.longitude = longitude
        self.rating = rating
        self.imageData = imageData
        self.text = text
    }
}
