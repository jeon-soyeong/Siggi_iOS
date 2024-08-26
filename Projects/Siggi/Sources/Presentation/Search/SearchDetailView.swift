//
//  SearchDetailView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/22.
//

import SwiftUI
import Common

struct SearchDetailView: View {
    @Environment(Router.self) private var searchRouter
    private let tapBarHeight: CGFloat = 85
    var searchText: String = ""
    let array: [String] = ["봉피양", "우래옥","능라도", "을밀대", "필동면옥", "g", "d", "a", "b"
    , "🍎", "🥝", "🍐", "🍊", "🍏", "🍒", "🍉", "🍇", "🫐", "c", "e", "f", "h", "i", "j", "k"]

    var body: some View {
        Text(searchText)
        
        Button(action: {
            searchRouter.pushView(screen: SearchScreen.searchSpot(spot: "미가훠궈"))
  
        }, label: {
            Image(systemName: "pencil")
                .resizable()
                .frame(width: 22, height: 22)
                .foregroundStyle(.gray)
        })
        
        Divider()
        ScrollView {            
            LazyVStack(alignment: .leading) {
                ForEach(array, id: \.self) { nangMyeon in
                    SearchResultsRow(place: nangMyeon)
                }
            }
        }
        .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: tapBarHeight, trailing: 0))
    }
}

#Preview {
    SearchDetailView()
}

//test용
struct SearchSpotView: View {
    var spot: String = ""
    
    var body: some View {
        Text(spot)
    }
}
