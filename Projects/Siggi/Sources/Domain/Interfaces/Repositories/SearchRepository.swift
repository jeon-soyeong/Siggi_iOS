//
//  SearchRepository.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/15.
//

import Foundation

public protocol SearchRepository {
    func fetchSearchPlaceResults(searchText: String, page: Int, size: Int) async throws -> SearchPlaces
}
