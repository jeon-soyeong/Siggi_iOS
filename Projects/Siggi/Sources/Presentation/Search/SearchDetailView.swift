//
//  SearchDetailView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/22.
//

import SwiftUI

struct SearchDetailView: View {
    var searchText: String = ""
    
    var body: some View {
        Text(searchText)
    }
}

#Preview {
    SearchDetailView()
}
