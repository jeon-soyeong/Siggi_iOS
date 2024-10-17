//
//  DefaultSearchRepository.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/15.
//

import Foundation

public final class DefaultSearchRepository: SearchRepository {
    private let apiService: APIService

    public init(apiService: APIService) {
        self.apiService = apiService
    }

    public func fetchSearchPlaceResults(searchText: String, page: Int, size: Int) async throws -> SearchPlaces {
        guard let request = URLRequest(type: SearchAPI.searchPlace(query: searchText, page: page, size: size)) else {
            throw APIError.failedRequest
        }

        return try await apiService.request(with: request)
    }
}

