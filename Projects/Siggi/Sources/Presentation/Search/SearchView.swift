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

struct SearchView: View {
    @Namespace var mapScope
    @State private var locationManager = LocationManager.shared
    @State private var clusterManager = ClusterManager()
    @State private var position: MapCameraPosition = .userLocation(fallback: .automatic)
    @State private var placeNames: [String]?
    @State private var isPresented: Bool = false
    @Bindable var searchRouter: Router
    @Query(sort: \PlaceRecord.date, order: .reverse) var placeRecords: [PlaceRecord]
    @State private var mapViewSize: CGSize = .zero

    var body: some View {
        NavigationStack(path: $searchRouter.route) {
            ZStack(alignment: .top) {
                Map(position: $position, scope: mapScope) {
                    UserAnnotation()

                    ForEach(clusterManager.clusterAnnotations.indices, id: \.self) { index in
                        let annotation = clusterManager.clusterAnnotations[index]
                        if let title = annotation.title {
                            Annotation(title, coordinate: annotation.coordinate) {
                                Image(.mapPin)
                                    .resizable()
                                    .frame(width: 30, height: 34)
                                    .onTapGesture {
                                        placeNames = annotation.titles
                                        isPresented = true
                                    }
                            }
                        }
                    }
                }
                .onAppear {
                    let annotations = placeRecords.map { record in
                        SiggiAnnotation(coordinate: CLLocationCoordinate2D(latitude: record.latitude, longitude: record.longitude), title: record.name, titles: [])
                    }
                    clusterManager.addAnnotations(annotations: annotations)
                }
                .onReadSize {
                    mapViewSize = $0
                }
                .sheet(isPresented: $isPresented) {
                    PlaceRecordsView(placeNames: $placeNames)
                        .presentationDetents([.medium, .fraction(0.9)])
                }
                .mapControls {
                    MapCompass()
                        .mapControlVisibility(.hidden)
                }
                .onChange(of: locationManager.region) { oldValue, newValue in
                    position = .region(newValue)
                }
                .onMapCameraChange { context in
                    let visibleMapRect = context.rect
                    let visibleMapRectWidth = visibleMapRect.size.width
                    let zoomScale = mapViewSize.width > 0 ? Double(mapViewSize.width / visibleMapRectWidth) : 1.0
                    clusterManager.clusterAnnotations(visibleMapRect: visibleMapRect, zoomScale: zoomScale)
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
