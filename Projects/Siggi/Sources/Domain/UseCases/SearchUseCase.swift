//
//  SearchUseCase.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/15.
//

import Foundation

public protocol SearchUseCase {
    func execute(searchText: String, page: Int, size: Int) async throws -> SearchPlaces
}

public final class DefaultSearchUseCase: SearchUseCase {
    private let searchRepository: SearchRepository

    public init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }

    public func execute(searchText: String, page: Int, size: Int) async throws -> SearchPlaces {
        return try await searchRepository.fetchSearchPlaceResults(searchText: searchText, page: page, size: size)
    }
}
