//
//  RecordDetailView.swift
//  Siggi
//
//  Created by 전소영 on 2025/01/02.
//

import Common
import SwiftData
import SwiftUI

struct RecordDetailView: View {
    @Environment(Router.self) private var recordRouter: Router
    @Environment(\.modelContext) private var modelContext
    @State private var isDelete: Bool = false
    private let maximumRating: Int = 5
    private let tabBarHeight: CGFloat = 85
    var placeRecord: PlaceRecord?

    var body: some View {
        ZStack(alignment: .top) {
            if let placeRecord = placeRecord {
                VStack {
                    NavigationBar(title: placeRecord.name,
                                  backButtonAction: { recordRouter.popView() },
                                  rightButtonAction: { recordRouter.popToRootView() })
                    Divider()
                }
                .background(.white)
                .zIndex(1)

                ScrollView {
                    VStack {
                        HStack {
                            ForEach(1...maximumRating, id: \.self) { count in
                                Image(systemName: count > placeRecord.rating ? "star" : "star.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(count > placeRecord.rating ? .gray : .red)
                            }
                        }
                        .padding(30)

                        if let imageData = placeRecord.imageData, imageData.count > 0 {
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

                        Image(.delete2)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(.horizontal, 18)
                            .onTapGesture {
                                isDelete = true
                            }
                    }
                }
                .safeAreaPadding(EdgeInsets(top: 60, leading: 0, bottom: tabBarHeight, trailing: 0))
                .scrollIndicators(.hidden)
                .navigationBarBackButtonHidden()

                if isDelete {
                    PopUpView(imageName: "delete",
                              message: "정말로 삭제하시겠습니까?",
                              leftButtonAction: {
                                  modelContext.delete(placeRecord)
                                  isDelete = false
                                  recordRouter.popToRootView()
                              },
                              rightButtonAction: {
                                  isDelete = false
                              },
                              leftButtonImageName: "yes",
                              rightButtonImageName: "no"
                    )
                }
            }
        }
    }
}

#Preview {
    RecordDetailView()
}
