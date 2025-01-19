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
    @Binding var placeName: String?
    @State private var isDelete: Bool = false
    @State private var recordToDelete: PlaceRecord?
    @Environment(\.modelContext) private var modelContext
    private let maximumRating: Int = 5
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    var body: some View {
            ZStack(alignment: .top) {
                if let placeName = placeName {
                    VStack(alignment: .leading) {
                        Text(placeName)
                            .font(.title)
                            .lineLimit(1)
                            .truncationMode(.tail)
                            .padding(.top, 30)
                            .padding(.leading)

                        Divider()
                    }
                    .background(.white)
                    .zIndex(1)
                }

                ScrollView {
                    ForEach(placeRecords.filter { $0.name == placeName }, id: \.self) { placeRecord in
                        VStack(alignment: .leading) {
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
                                        ForEach(imageData, id: \.self) { data in
                                            if let recordImage = UIImage(data: data) {
                                                Image(uiImage: recordImage)
                                                    .resizable()
                                                    .scaledToFill()
                                                    .frame(width: 100, height: 130)
                                                    .cornerRadius(15)
                                                    .clipped()
                                            }
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
                .scrollIndicators(.hidden)
                .safeAreaPadding(EdgeInsets(top: 90, leading: 0, bottom: 0, trailing: 0))

                if isDelete, let placeRecordToDelete = recordToDelete {
                    PopUpView(message: "정말로 삭제하시겠습니까?",
                              leftButtonAction: {
                                  do {
                                      modelContext.delete(placeRecordToDelete)
                                      try modelContext.save()
                                      isDelete = false
                                      recordToDelete = nil
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
                    .zIndex(2)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
    }
}
