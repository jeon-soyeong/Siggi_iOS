//
//  SearchViewModel.swift
//  Siggi
//
//  Created by 전소영 on 2024/08/31.
//

import SwiftUI
import Common

@Observable final class SearchViewModel: ViewModelType {
    var state: State
    private let searchUseCase: SearchUseCase

    enum Action {
        case fetchSearchPlace(searchText: String)
    }

    struct State {
        let perPage = 15
        var currentPage = 1
        var searchPlaceResults: [Document]
        var isEnd: Bool = false
        var isLoading = false
    }

    init(searchUseCase: SearchUseCase) {
        self.state = State(searchPlaceResults: [])
        self.searchUseCase = searchUseCase
    }

    func transform(type: Action) {
        Task {
            do {
                switch type {
                case .fetchSearchPlace(let searchText):
                    try await fetchSearchPlaceResults(searchText: searchText)
                }
            } catch {
                if let error = error as? APIError {
                     print(error.description)
                 } else {
                     print(error.localizedDescription)
                 }
            }
        }
    }

    func fetchSearchPlaceResults(searchText: String) async throws {
        guard state.isEnd == false else { return }
        state.isLoading = true
        let searchPlace = try await searchUseCase.execute(searchText: searchText, page: state.currentPage, size: state.perPage)
        state.searchPlaceResults.append(contentsOf: searchPlace.documents)
        state.currentPage += 1
        state.isEnd = searchPlace.meta.isEnd
        state.isLoading = false
    }
}
