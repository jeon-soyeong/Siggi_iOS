//
//  SelectedPlaceView.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/01.
//

import SwiftUI
import Common

public struct SelectedPlaceView: View {
    @Environment(Router.self) private var searchRouter
    var place: String = ""
    
    public var body: some View {
        NavigationBar(title: place,
                      backButtonAction: searchRouter.popView,
                      rightButtonAction: searchRouter.popToRootView)
    }
}

#Preview {
    SelectedPlaceView()
}
