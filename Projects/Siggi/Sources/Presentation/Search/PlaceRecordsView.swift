//
//  PlaceRecordsView.swift
//  Siggi
//
//  Created by 전소영 on 2025/01/08.
//

import SwiftUI

struct PlaceRecordsView: View {
    @Binding var record: [PlaceRecord]?
    private let maximumRating: Int = 5
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일 EEEE"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }()

    var body: some View {
        if let record = record,
           let placeName = record.first?.name {
            ZStack(alignment: .top) {
                VStack(alignment: .leading) {
                    Text(placeName)
                        .font(.title)
                        .lineLimit(1)
                        .truncationMode(.tail)
                        .padding(.top, 30)

                    Divider()
                }
                .background(.white)
                .zIndex(1)

                ScrollView {
                    ForEach(record.indices, id: \.self) { index in
                        VStack(alignment: .leading) {
                            let placeRecord = record[index]

                            let formattedDate = dateFormatter.string(from: placeRecord.date)
                            Text(formattedDate)
                                .fontWeight(.medium)

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
                        .padding(.vertical)

                        Divider()
                    }
                }
                .scrollIndicators(.hidden)
                .safeAreaPadding(EdgeInsets(top: 90, leading: 0, bottom: 0, trailing: 0))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        }
    }
}
