//
//  SearchPlaces.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/19.
//

import Foundation

// MARK: - SearchPlaces
struct SearchPlaces: Codable {
    let meta: Meta
    let documents: [Document]

    init(meta: Meta, documents: [Document]) {
        self.meta = meta
        self.documents = documents
    }
}

// MARK: - Meta
struct Meta: Codable {
    let isEnd: Bool

    init(isEnd: Bool) {
        self.isEnd = isEnd
    }

    enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
    }
}

// MARK: - Document
struct Document: Codable, Hashable {
    let placeName: String
    let x: String
    let y: String
    let roadAddressName: String
    let phone: String

    init(placeName: String, x: String, y: String, roadAddressName: String, phone: String) {
        self.placeName = placeName
        self.x = x
        self.y = y
        self.roadAddressName = roadAddressName
        self.phone = phone
    }

    enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case x
        case y
        case roadAddressName = "road_address_name"
        case phone
    }
}
