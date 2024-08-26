//
//  SearchScreen.swift
//  Siggi
//
//  Created by 전소영 on 2024/08/20.
//

import Foundation

public enum SearchScreen: Hashable {
    case seachDetail(searchText: String)
    case searchSpot(spot: String)
}
