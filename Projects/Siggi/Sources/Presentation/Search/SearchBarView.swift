//
//  SearchBarView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/10.
//

import SwiftUI

struct SearchBarView: View {
    @State var searchText: String = ""
    
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
                    // api query = searchText
                    // 결과 리스트 searchDetailView 로 넘기기
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

#Preview {
    SearchBarView()
}
