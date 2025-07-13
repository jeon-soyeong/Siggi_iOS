//
//  PlaceRecordsView.swift
//  Siggi
//
//  Created by 전소영 on 2025/01/08.
//

import Common
import SwiftData
import SwiftUI

struct PlaceRecordsView: View {
    @Query(sort: \PlaceRecord.date, order: .reverse) var placeRecords: [PlaceRecord]
    @Binding var placeNames: [String]?
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) var dismiss
    @State private var isDelete: Bool = false
    @State private var recordToDelete: PlaceRecord?
    private let maximumRating: Int = 5
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    private var totalDisplayedRecordsCount: Int {
        guard let namesToFilter = placeNames else { return 0 }
        return placeRecords.filter { namesToFilter.contains($0.name) }.count
    }

    var body: some View {
        ZStack(alignment: .top) {
            ScrollView {
                if let placeNames = placeNames {
                    ForEach(placeNames, id: \.self) { place in
                        ForEach(placeRecords.filter { $0.name == place }, id: \.self) { placeRecord in
                            VStack(alignment: .leading) {
                                Text(place)
                                    .font(.title)

                                HStack {
                                    let formattedDate = dateFormatter.string(from: placeRecord.date)
                                    Text(formattedDate)
                                        .fontWeight(.medium)

                                    Spacer()

                                    Button(action: {
                                        recordToDelete = placeRecord
                                        isDelete = true
                                    }, label: {
                                        Image(.trashCan)
                                            .resizable()
                                            .frame(width: 18, height: 15)
                                    })
                                }

                                HStack(spacing: 2) {
                                    ForEach(1...maximumRating, id: \.self) { count in
                                        Image(systemName: count > placeRecord.rating ? "star" : "star.fill")
                                            .resizable()
                                            .frame(width: 15, height: 15)
                                            .foregroundColor(count > placeRecord.rating ? .gray : .red)
                                    }
                                }

                                if let imageData = placeRecord.imageData {
                                    ScrollView(.horizontal) {
                                        LazyHStack {
                                            ForEach(imageData.indices, id: \.self) { index in
                                                let data = imageData[index]
                                                let imageCacheKey = "\(placeRecord.id.uuidString)_\(index)"

                                                AsyncCachedImageView(
                                                    imageData: data,
                                                    cacheKey: imageCacheKey,
                                                    cornerRadius: 15,
                                                    defaultImage: (type: .asset("siggiIcon"), width: 50, height: 50)
                                                )
                                                .frame(width: 100, height: 130)
                                            }
                                        }
                                    }
                                }

                                if let text = placeRecord.text, text.count > 0 {
                                    Text(text)
                                        .fontWeight(.light)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                }

                            }
                            .padding()

                            Divider()
                        }
                    }
                }
            }
            .scrollIndicators(.hidden)
            .safeAreaPadding(EdgeInsets(top: 20, leading: 0, bottom: 20, trailing: 0))

            if isDelete, let placeRecordToDelete = recordToDelete {
                PopUpView(message: "정말로 삭제하시겠습니까?",
                          leftButtonAction: {
                    do {
                        modelContext.delete(placeRecordToDelete)
                        try modelContext.save()
                        isDelete = false
                        recordToDelete = nil

                        if totalDisplayedRecordsCount == 0 {
                            dismiss()
                        }
                    } catch {
                        print("Failed to delete: \(error)")
                    }
                },
                          rightButtonAction: {
                    isDelete = false
                    recordToDelete = nil
                },
                          leftButtonImageName: "yes",
                          rightButtonImageName: "no",
                          height: 250
                )
                .zIndex(1)
            }
        }
    }
}
