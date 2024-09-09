//
//  ContentView.swift
//  Siggi
//
//  Created by 전소영 on 2024/05/30.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI
import Common

struct ContentView: View {
    @Environment(AppRootManager.self) private var appRootManager
    @Environment(Router.self) var searchRouter
    @Environment(Router.self) var recordRouter
    @State private var selectedTab: Tab = .search
    
    var body: some View {
        switch appRootManager.currentRoot {
        case .splash:
            SplashView()
        case .home:
            ZStack(alignment: .bottom) {
                switch selectedTab {
                case .search:
                    SearchView(searchRouter: searchRouter)
                case .record:
                    RecordView(recordRouter: recordRouter)
                }
                
                ZStack {
                    RoundedRectangle(cornerRadius: 20)
                        .fill(Color.white)
                        .shadow(color: .black.opacity(0.2), radius: 20, x: 0, y: 5)
                        .frame(height: 85)
                    
                    TabView(selection: $selectedTab) {
                        Text("")
                            .tabItem {
                                Label("검색", systemImage: "magnifyingglass")
                            }
                            .tag(Tab.search)
                        
                        Text("")
                            .tabItem {
                                Label("기록", systemImage: "pencil.tip")
                            }
                            .tag(Tab.record)
                    }
                    .background(Color.clear)
                    .frame(height: 85)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .accentColor(.red)
                    .onAppear {
                        UITabBar.appearance().unselectedItemTintColor = .darkGray
                    }
                }
            }
            .edgesIgnoringSafeArea(.bottom)
        }
    }
}

#Preview {
    ContentView()
}
