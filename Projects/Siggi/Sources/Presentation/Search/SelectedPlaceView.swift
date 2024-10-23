//
//  SelectedPlaceView.swift
//  Siggi
//
//  Created by 전소영 on 2024/09/01.
//

import SwiftUI
import Common
import MapKit

public struct SelectedPlaceView: View {
    @Environment(Router.self) private var searchRouter
    var place: Document?
    private let tabBarHeight: CGFloat = 85

    public var body: some View {
        if let place = place {
            NavigationBar(title: place.placeName,
                          backButtonAction: searchRouter.popView,
                          rightButtonAction: searchRouter.popToRootView)

            ZStack(alignment: .bottom) {
                Map {
                    if let x = Double(place.x), let y = Double(place.y) {
                        let coordinate = CLLocationCoordinate2D(latitude: y, longitude: x)
                        Annotation(place.placeName, coordinate: coordinate) {
                            Image(.mapPin)
                                .resizable()
                                .frame(width: 40, height: 48)
                        }
                    }
                }
                .mapControls {
                    MapCompass()
                        .mapControlVisibility(.hidden)
                }

                Image(.recording)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding(EdgeInsets(top: 0, leading: 18, bottom: tabBarHeight, trailing: 18))
                    .onTapGesture {
                        searchRouter.pushView(screen: SearchScreen.recordPlace(place: place))
                    }
            }
        }
    }
}

#Preview {
    SelectedPlaceView()
}
