//
//  SearchPlaces.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/19.
//

import Foundation

// MARK: - SearchPlaces
public struct SearchPlaces: Codable {
    public let meta: Meta
    public let documents: [Document]

    public init(meta: Meta, documents: [Document]) {
        self.meta = meta
        self.documents = documents
    }
}

// MARK: - Meta
public struct Meta: Codable {
    public let isEnd: Bool

    public init(isEnd: Bool) {
        self.isEnd = isEnd
    }

    private enum CodingKeys: String, CodingKey {
        case isEnd = "is_end"
    }
}

// MARK: - Document
public struct Document: Codable, Hashable {
    public let placeName: String
    public let x: String
    public let y: String
    public let roadAddressName: String
    public let phone: String

    public init(placeName: String, x: String, y: String, roadAddressName: String, phone: String) {
        self.placeName = placeName
        self.x = x
        self.y = y
        self.roadAddressName = roadAddressName
        self.phone = phone
    }

    private enum CodingKeys: String, CodingKey {
        case placeName = "place_name"
        case x
        case y
        case roadAddressName = "road_address_name"
        case phone
    }
}
