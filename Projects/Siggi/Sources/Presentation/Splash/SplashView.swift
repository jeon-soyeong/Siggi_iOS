//
//  SplashView.swift
//  Siggi
//
//  Created by 전소영 on 2024/06/11.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI

struct SplashView: View {
    @Environment(AppRootManager.self) private var appRootManager

    var body: some View {
        Image("siggiIcon")
            .resizable()
            .frame(width: 90, height: 90)
            .onAppear() {
                DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                    withAnimation(.easeOut) {
                        appRootManager.currentRoot = .home
                    }
                }
            }
    }
}

#Preview {
    SplashView()
}
