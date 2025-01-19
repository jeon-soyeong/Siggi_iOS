//
//  SearchView.swift
//  Siggi
//
//  Created by 전소영 on 2024/06/11.
//  Copyright © 2024 Siggi. All rights reserved.
//

import Common
import MapKit
import SwiftData
import SwiftUI

public struct SearchView: View {
    @Namespace var mapScope
    @State private var locationManager = LocationManager.shared
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var placeName: String?
    @State private var showModal: Bool = false
    @Bindable var searchRouter: Router
    @Query(sort: \PlaceRecord.date, order: .reverse) var placeRecords: [PlaceRecord]

    public var body: some View {
        NavigationStack(path: $searchRouter.route) {
            ZStack(alignment: .top) {
                Map(position: $position, scope: mapScope) {
                    UserAnnotation()

                    ForEach(placeRecords, id: \.self) { record in
                        let coordinate = CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude)
                        Annotation(record.name, coordinate: coordinate) {
                            Image(.mapPin)
                                .resizable()
                                .frame(width: 30, height: 34)
                                .onTapGesture {
                                    placeName = record.name
                                    showModal = true
                                }
                        }
                    }
                }
                .sheet(isPresented: $showModal) {
                    PlaceRecordsView(placeName: $placeName)
                        .presentationDetents([.medium, .fraction(0.9)])
                }
                .mapControls {
                    MapCompass()
                        .mapControlVisibility(.hidden)
                }
                .onChange(of: locationManager.region) { oldValue, newValue in
                    position = .region(newValue)
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
                .navigationBarBackButtonHidden()
            }
            .mapScope(mapScope)
            .navigationDestination(for: SearchScreen.self) { screen in
                switch screen {
                case .searchResults(let searchText):
                    SearchResultsView(searchText: searchText)
                        .navigationBarBackButtonHidden()
                case .selectedPlace(let place):
                    SelectedPlaceView(place: place)
                        .navigationBarBackButtonHidden()
                case .recordPlace(let place):
                    RecordPlaceView(place: place)
                        .navigationBarBackButtonHidden()
                }
            }
        }
    }
}

#Preview {
    SearchView(searchRouter: Router())
}
