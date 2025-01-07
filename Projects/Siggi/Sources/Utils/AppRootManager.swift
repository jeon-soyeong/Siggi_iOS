//
//  AppRootManager.swift
//  Siggi
//
//  Created by 전소영 on 2024/06/11.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI

@Observable public final class AppRootManager {
    var currentRoot: AppRoots = .splash
    
    enum AppRoots {
        case splash
        case search
        case record
    }
}
