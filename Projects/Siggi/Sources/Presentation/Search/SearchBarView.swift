//
//  SearchBarView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/10.
//

import SwiftUI
import Common

struct SearchBarView: View {
    @Environment(Router.self) private var searchRouter
    @State private var searchText: String = ""
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 45)
                .foregroundStyle(.white)
            HStack {
                Spacer()
                TextField("식도락 장소 검색 🍽️", text: $searchText)
                    .fontWeight(.medium)
                    .onAppear {
                        searchText = ""
                    }
                    .onSubmit {
                        searchRouter.pushView(screen: SearchScreen.searchResults(searchText: searchText))
                    }
                Button(action: {
                    if !searchText.isEmpty {
                        searchRouter.pushView(screen: SearchScreen.searchResults(searchText: searchText))
                    }
                    // api query = searchText
                }, label: {
                    Image(systemName: "magnifyingglass")
                        .resizable()
                        .frame(width: 22, height: 22)
                        .foregroundStyle(.gray)
                })
            }
            .padding(10)
        }
    }
}
