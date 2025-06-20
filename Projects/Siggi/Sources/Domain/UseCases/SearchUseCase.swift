//
//  SearchUseCase.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/15.
//

import Foundation

protocol SearchUseCase {
    func execute(searchText: String, page: Int, size: Int) async throws -> SearchPlaces
}

final class DefaultSearchUseCase: SearchUseCase {
    private let searchRepository: SearchRepository

    init(searchRepository: SearchRepository) {
        self.searchRepository = searchRepository
    }

    func execute(searchText: String, page: Int, size: Int) async throws -> SearchPlaces {
        return try await searchRepository.fetchSearchPlaceResults(searchText: searchText, page: page, size: size)
    }
}
