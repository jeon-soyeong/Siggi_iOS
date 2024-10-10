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
    @State private var searchViewModel = SearchViewModel()
    private let tapBarHeight: CGFloat = 85
    var searchText: String = ""

    public var body: some View {
        NavigationBar(title: searchText,
                      backButtonAction: searchRouter.popView,
                      rightButtonAction: searchRouter.popView)
        Divider()
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(searchViewModel.state.searchPlaceResults.indices, id: \.self) { index in
                    SearchResultsRow(place: searchViewModel.state.searchPlaceResults[index])
                        .onTapGesture {
                            searchRouter.pushView(screen: SearchScreen.selectedPlace(place: searchViewModel.state.searchPlaceResults[index]))
                        }
                }
            }
        }
        .onAppear {
            searchViewModel.transform(type: .searchButtonTapped(searchText: searchText))
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: tapBarHeight, trailing: 0))
    }
}

#Preview {
    SearchResultsView()
}
