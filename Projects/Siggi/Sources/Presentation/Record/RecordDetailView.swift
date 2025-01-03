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
    private let maximumRating: Int = 5
    private let tabBarHeight: CGFloat = 85

    var body: some View {
        if let placeRecord = placeRecord {
            NavigationBar(title: placeRecord.name,
                          backButtonAction: recordRouter.popView,
                          rightButtonAction: recordRouter.popToRootView)
            Divider()
            
            ScrollView {
                HStack {
                    ForEach(1...maximumRating, id: \.self) { count in
                        Image(systemName: count > placeRecord.rating ? "star" : "star.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(count > placeRecord.rating ? .gray : .red)
                    }
                }
                .padding(30)

                if let imageData = placeRecord.imageData {
                    ScrollView(.horizontal) {
                        LazyHStack {
                            ForEach(imageData, id: \.self) { data in
                                if let recordImage = UIImage(data: data) {
                                    Image(uiImage: recordImage)
                                        .resizable()
                                        .scaledToFill()
                                        .frame(width: 150, height: 200)
                                        .cornerRadius(15)
                                        .clipped()
                                }
                            }
                        }
                    }
                    .padding(20)
                }

                if let text = placeRecord.text, text.count > 0 {
                    Text(text)
                        .fontWeight(.medium)
                        .padding(20)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.gray, lineWidth: 1)
                        )
                        .padding(20)
                }
            }
            .safeAreaPadding(EdgeInsets(top: 0, leading: 0, bottom: tabBarHeight, trailing: 0))
            .scrollIndicators(.hidden)
            .navigationBarBackButtonHidden()
        }
    }
}

#Preview {
    RecordDetailView()
}
