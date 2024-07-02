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
    @State private var selectedTab: Tab = .search
    
    var body: some View {
        switch appRootManger.currentRoot {
        case .splash:
            SplashView()
        case .home:
            TabView(selection: $selectedTab) {
                NavigationStack {
                    SearchView()
                }
                .tabItem {
                    Label("검색", systemImage: "magnifyingglass")
                }
                .tag(Tab.search)
                
                NavigationStack {
                    RecordView()
                }
                .tabItem {
                    Label("기록", systemImage: "pencil.tip")
                }
                .tag(Tab.record)
            }
            .accentColor(.red)
            .onAppear(perform: {
                UITabBar.appearance().unselectedItemTintColor = .darkGray
            })
        }
    }
}

#Preview {
    ContentView()
}
