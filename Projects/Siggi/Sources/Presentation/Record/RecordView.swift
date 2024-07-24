//
//  RecordView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/02.
//

import SwiftUI

struct RecordView: View {
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            Text("RecordView!")
        }
    }
}

#Preview {
    RecordView()
}
