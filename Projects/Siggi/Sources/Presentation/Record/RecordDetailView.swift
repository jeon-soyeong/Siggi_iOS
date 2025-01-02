//
//  RecordDetailView.swift
//  Siggi
//
//  Created by 전소영 on 2025/01/02.
//

import Common
import SwiftUI

struct RecordDetailView: View {
    @Environment(Router.self) private var recordRouter: Router
    var placeRecord: PlaceRecord?

    var body: some View {
        if let placeRecordName = placeRecord?.name {
            NavigationBar(title: placeRecordName,
                          backButtonAction: recordRouter.popView,
                          rightButtonAction: recordRouter.popToRootView)
        }

        Divider()

        .navigationBarBackButtonHidden()

    }
}

#Preview {
    RecordDetailView()
}
