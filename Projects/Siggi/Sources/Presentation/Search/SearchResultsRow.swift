//
//  SearchResultsRow.swift
//  Siggi
//
//  Created by 전소영 on 2024/08/19.
//

import SwiftUI

struct SearchResultsRow: View {
    var place: String
    
    var body: some View {
        HStack {
            Image("place")
                .resizable()
                .frame(width: 18, height: 16)
            
            Text(place)
        }
        .padding(EdgeInsets(top: 8, leading: 14, bottom: 8, trailing: 0))
        Divider()
    }
}

#Preview {
    SearchResultsRow(place: "")
}
