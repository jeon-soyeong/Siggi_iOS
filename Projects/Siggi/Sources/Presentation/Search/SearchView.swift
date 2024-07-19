//
//  SearchView.swift
//  Siggi
//
//  Created by 전소영 on 2024/06/11.
//  Copyright © 2024 Siggi. All rights reserved.
//

import SwiftUI
import MapKit

struct SearchView: View {
    @Namespace var mapScope
    @State private var locationManager = LocationManager()
    @State private var position: MapCameraPosition = .automatic
    @State private var isPositionUpdated = false
    
    var body: some View {
        ZStack(alignment: .top) {
            Map(position: $position, scope: mapScope) {
                UserAnnotation()
            }
            .mapControls {
                MapCompass()
                    .mapControlVisibility(.hidden)
            }
            .task {
                try? await locationManager.startCurrentLocationUpdates()
            }
            .onMapCameraChange() { context in
                position = .region(context.region)
            }
            .onChange(of: locationManager.position) {
                if !isPositionUpdated {
                    position = locationManager.position
                    isPositionUpdated = true
                }
            }

            VStack(alignment: .trailing) {
                SearchBarView()
                
                VStack {
                    MapUserLocationButton(scope: mapScope)
                        .buttonBorderShape(.circle)
                    MapCompass(scope: mapScope)
                }
            }
            .padding(14)
        }
        .mapScope(mapScope)
    }
}

#Preview {
    SearchView()
}
