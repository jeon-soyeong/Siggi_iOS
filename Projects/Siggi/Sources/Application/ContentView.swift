//
//  ContentView.swift
//  Siggi
//
//  Created by 전소영 on 2024/05/30.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    @Environment(AppRootManager.self) private var appRootManger
    
    var body: some View {
        switch appRootManger.currentRoot {
        case .splash:
            SplashView()
        case .search:
            SearchView()
        case .home:
        }
    }
}

#Preview {
    ContentView()
}
