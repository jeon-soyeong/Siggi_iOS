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
    private let tapBarHeight: CGFloat = 85
    var searchText: String = ""
    //test
    let array: [String] = ["봉피양", "우래옥","능라도", "을밀대", "필동면옥", "g", "d", "a", "b"
                           , "🍎", "🥝", "🍐", "🍊", "🍏", "🍒", "🍉", "🍇", "🫐", "c", "e", "f", "h", "i", "j", "k"]
    
    public var body: some View {
        NavigationBar(title: searchText,
                      backButtonAction: searchRouter.popView,
                      rightButtonAction: searchRouter.popView)
        Divider()
        ScrollView {
            LazyVStack(alignment: .leading) {
                ForEach(array, id: \.self) { nangMyeon in
                    SearchResultsRow(place: nangMyeon)
                        .onTapGesture {
                            searchRouter.pushView(screen: SearchScreen.selectedPlace(place: nangMyeon))
                        }
                }
            }
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: tapBarHeight, trailing: 0))
    }
}

#Preview {
    SearchResultsView()
}
