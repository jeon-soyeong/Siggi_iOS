//
//  RecordView.swift
//  Siggi
//
//  Created by 전소영 on 2024/07/02.
//

import Common
import SwiftData
import SwiftUI

public struct RecordView: View {
    @Bindable var recordRouter: Router
    @Query(sort: \PlaceRecord.date, order: .reverse) var placeRecords: [PlaceRecord]
    private let tabBarHeight: CGFloat = 85
    let columns = [GridItem(.flexible(minimum: 160, maximum: 200), spacing: 10),
                   GridItem(.flexible(minimum: 160, maximum: 200), spacing: 10)]

    public var body: some View {
        NavigationStack(path: $recordRouter.route) {
            ZStack(alignment: .top) {
                VStack {
                    HStack(spacing: 2) {
                        Image(.siggiIcon)
                            .resizable()
                            .frame(width: 30, height: 30)
                        Text("기록")
                            .font(.title3)
                        Spacer()
                    }
                    .frame(height: 40)
                    .padding(.horizontal, 14)

                    Divider()
                }
                .background(.white)
                .zIndex(1)

                ScrollView {
                    LazyVGrid(columns: columns, spacing: 10) {
                        ForEach(placeRecords, id: \.self) { record in
                            ZStack(alignment: .bottomLeading) {
                                if let imageData = record.imageData?.first,
                                    let recordImage = UIImage(data: imageData) {
                                    Image(uiImage: recordImage)
                                        .resizable()
                                        .cornerRadius(10)
                                        .frame(height: 210)
                                } else {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 10)
                                            .frame(height: 210)
                                            .foregroundColor(.gray)

                                        Image(.siggiIcon)
                                            .resizable()
                                            .frame(width: 130, height: 130)
                                    }
                                }

                                Text(record.name)
                                    .font(.system(size: 15, weight: .bold))
                                    .foregroundStyle(.white)
                                    .padding(10)
                            }
                            .onTapGesture {
                                recordRouter.pushView(screen: RecordScreen.recordDetail(placeRecord: record))
                            }
                        }
                    }
                    .padding(.horizontal, 10)
                }
                .safeAreaPadding(EdgeInsets(top: 60, leading: 0, bottom: tabBarHeight, trailing: 0))
            }
            .navigationDestination(for: RecordScreen.self) { screen in
                switch screen {
                case .recordDetail(let placeRecord):
                    RecordDetailView(placeRecord: placeRecord)
                }
            }
        }
    }
}

#Preview {
    RecordView(recordRouter: Router())
}
