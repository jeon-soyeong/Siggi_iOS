//
//  DIContainerModifier.swift
//  Siggi
//
//  Created by 전소영 on 2024/06/11.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI
import Common

public struct DIContainerModifier: ViewModifier {
    @State private var appRootManager = AppRootManager()
    @Bindable var searchRouter = Router()
    @Bindable var recordRouter = Router()
    
    public func body(content: Content) -> some View {
        content
            .environment(appRootManager)
            .environment(searchRouter)
            .environment(recordRouter)
    }
}
