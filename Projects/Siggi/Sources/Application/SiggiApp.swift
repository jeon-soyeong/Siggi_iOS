//
//  SiggiApp.swift
//  Siggi
//
//  Created by 전소영 on 2024/05/30.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI

@main
struct SiggiApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
                .serviceDIContainer()
        }
    }
}
