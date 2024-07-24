//
//  SearchBarView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/10.
//

import SwiftUI

struct SearchBarView: View {
    @State private var searchText: String = ""
    @Binding var path: NavigationPath
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 12)
                .frame(height: 45)
                .foregroundStyle(.white)
            HStack {
                Spacer()
                TextField("식도락 장소 검색 🍽️", text: $searchText)
                    .fontWeight(.medium)
                Button(action: {
                    if !searchText.isEmpty {
                        path.append(searchText)
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
