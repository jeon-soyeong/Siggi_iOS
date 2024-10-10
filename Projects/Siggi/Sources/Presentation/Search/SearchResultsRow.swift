//
//  SearchResultsRow.swift
//  Siggi
//
//  Created by 전소영 on 2024/08/19.
//

import SwiftUI

public struct SearchResultsRow: View {
    var place: Document

    public var body: some View {
        HStack(alignment: .top) {
            Image(.place)
                .resizable()
                .frame(width: 18, height: 16)
                .padding(.top, 2)

            VStack(alignment: .leading, spacing: 5) {
                Text(place.placeName)
                Text(place.roadAddressName)
                    .font(.system(size: 14))
                    .foregroundStyle(.gray)
            }
        }
        .padding(EdgeInsets(top: 6, leading: 14, bottom: 6, trailing: 0))
        Divider()
    }
}

#Preview {
    SearchResultsRow(place: Document(placeName: "미가훠궈양고기", x: "127.09820149830225", y: "37.32271855940384", roadAddressName: "경기 용인시 수지구 풍덕천로140번길 15", phone: "031-272-2222"))
}
