//
//  RecordPlaceView.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/23.
//

import SwiftUI
import Common

struct RecordPlaceView: View {
    @Environment(Router.self) private var searchRouter
    var place: Document?

    var body: some View {
        if let place = place {
            NavigationBar(title: place.placeName,
                          backButtonAction: searchRouter.popView,
                          rightButtonAction: searchRouter.popToRootView)

            // TODO: camera, image 
        }
    }
}

#Preview {
    RecordPlaceView()
}
