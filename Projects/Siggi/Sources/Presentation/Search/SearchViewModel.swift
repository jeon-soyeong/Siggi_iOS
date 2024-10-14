//
//  SearchViewModel.swift
//  Siggi
//
//  Created by 전소영 on 2024/08/31.
//

import SwiftUI

@Observable public final class SearchViewModel: ViewModelType {
    public var state: State

    public enum Action {
        case searchButtonTapped(searchText: String)
    }

    public struct State {
        let perPage = 15
        var currentPage = 1
        var searchPlaceResults: [Document]
        var isEnd: Bool = false
        var isRequesting = false
    }

    public init() {
        self.state = State(searchPlaceResults: [])
    }

    public func transform(type: Action) {
        Task {
            switch type {
            case .searchButtonTapped(let searchText):
                try await fetchSearchPlaceResults(searchText: searchText)
            }
        }
    }

    public func fetchSearchPlaceResults(searchText: String) async throws {
        guard state.isEnd == false else { return }
        state.isRequesting = true
        guard let request = URLRequest(type: SearchAPI.searchPlace(query: searchText, page: state.currentPage, size: state.perPage)) else {
            return
        }
        // TODO: UseCase로 변경
        let searchPlace: SearchPlaces = try await APIService().request(with: request)
        print("searchPlace: \(searchPlace)")
        state.searchPlaceResults.append(contentsOf: searchPlace.documents)
        state.currentPage += 1
        state.isEnd = searchPlace.meta.isEnd
        state.isRequesting = false
    }
}
