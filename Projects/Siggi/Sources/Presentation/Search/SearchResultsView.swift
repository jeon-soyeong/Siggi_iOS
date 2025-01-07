//
//  SearchResultsView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/22.
//

import SwiftUI
import Common

public struct SearchResultsView: View {
    @Environment(Router.self) private var searchRouter
    @State private var searchViewModel = SearchViewModel(
        searchUseCase: DefaultSearchUseCase(
            searchRepository: DefaultSearchRepository(
                apiService: APIService()
            )
        )
    )
    private let tabBarHeight: CGFloat = 85
    var searchText: String = ""

    public var body: some View {
        NavigationBar(title: searchText,
                      backButtonAction: searchRouter.popView,
                      rightButtonAction: searchRouter.popToRootView)
        Divider()

        ZStack {
            ScrollView {
                LazyVStack(alignment: .leading) {
                    ForEach(searchViewModel.state.searchPlaceResults, id: \.self) { searchPlace in
                        SearchResultsRow(place: searchPlace)
                            .onAppear {
                                if searchPlace == searchViewModel.state.searchPlaceResults.last {
                                    searchViewModel.transform(type: .fetchSearchPlace(searchText: searchText))
                                }
                            }
                            .onTapGesture {
                                searchRouter.pushView(screen: SearchScreen.selectedPlace(place: searchPlace))
                            }
                    }
                }
            }
            .onAppear {
                searchViewModel.transform(type: .fetchSearchPlace(searchText: searchText))
            }

            if searchViewModel.state.isLoading {
                ProgressView()
                    .progressViewStyle(.circular)
            }
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: tabBarHeight, trailing: 0))
    }
}

#Preview {
    SearchResultsView()
}
