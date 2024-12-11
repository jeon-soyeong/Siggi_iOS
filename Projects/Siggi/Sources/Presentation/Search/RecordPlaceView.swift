//
//  RecordPlaceView.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/23.
//

import Common
import PhotosUI
import SwiftData
import SwiftUI

struct RecordPlaceView: View {
    @Environment(Router.self) private var searchRouter
    @Environment(\.modelContext) private var modelContext
    @State private var selectedImages: [UIImage] = []
    @State private var rating: Int = 0
    @State private var text: String = ""
    @State private var isLoading: Bool = false 
    @State private var isRegister: Bool = false
    @FocusState private var isFocused: Bool
    private let maximumRating: Int = 5
    var place: Document?

    var body: some View {
        ZStack {
            VStack {
                if let place = place {
                    NavigationBar(title: place.placeName,
                                  backButtonAction: { searchRouter.popView() },
                                  rightButtonAction: { searchRouter.popToRootView() })
                    Divider()

                    ScrollView {
                        HStack {
                            ForEach(1...maximumRating, id: \.self) { count in
                                Image(systemName: count > rating ? "star" : "star.fill")
                                    .resizable()
                                    .frame(width: 30, height: 30)
                                    .foregroundColor(count > rating ? .gray : .red)
                                    .onTapGesture {
                                        rating = count
                                    }
                            }
                        }
                        .padding(30)

                        PhotoView(selectedImages: $selectedImages, isLoading: $isLoading)
                            .padding(20)

                        VStack(alignment: .trailing) {
                            TextField("리뷰를 작성해주세요 🖊️", text: $text, axis: .vertical)
                                .focused($isFocused)
                                .lineLimit(9...)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(Color.gray, lineWidth: 1)
                                        .padding(-10)
                                )
                                .padding(.horizontal, 30)
                                .onChange(of: text) { oldValue, newValue in
                                    if newValue.count > 500 {
                                        text = String(newValue.prefix(500))
                                    }
                                }

                            Text("\(text.count) / 500")
                                .font(.caption)
                                .foregroundColor(.gray)
                                .padding(.top, 10)
                                .padding(.trailing, 20)
                        }
                        .padding(.top, 20)

                        Image(.save)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .padding(EdgeInsets(top: 30, leading: 18, bottom: 0, trailing: 18))
                            .onTapGesture {
                                isRegister = true

                                Task {
                                    var selectedImageDatas: [Data] = []
                                    for selectedImage in selectedImages {
                                        if let selectedImageData = selectedImage.pngData() {
                                            selectedImageDatas.append(selectedImageData)
                                        }
                                    }

                                    guard let latitude = Double(place.y),
                                          let longitude = Double(place.x) else {
                                        isRegister = false
                                        return
                                    }

                                    do {
                                        modelContext.insert(PlaceRecord(name: place.placeName, latitude: latitude, longitude: longitude, rating: rating, imageData: selectedImageDatas, text: text))
                                        try modelContext.save()
                                        isRegister = false
                                        searchRouter.popToRootView()
                                    } catch {
                                        isRegister = false
                                        print("Failed to save context: \(error)")
                                    }
                                }
                            }
                    }
                    .contentShape(Rectangle())
                    .onTapGesture {
                        isFocused = false
                    }
                    .scrollIndicators(.hidden)
                }
            }

            if isLoading {
                PopUpView(imageName: "gallery", message: "사진을 등록하는 중입니다.\n잠시만 기다려주세요!")
            } else if isRegister {
                PopUpView(imageName: "complete", message: "저장 중입니다.\n잠시만 기다려주세요!")
            }
        }
    }
}

#Preview {
    RecordPlaceView()
}

struct PhotoView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @Binding var selectedImages: [UIImage]
    @Binding var isLoading: Bool
    @State var isRemove: Bool = false

    var body: some View {
        HStack {
            PhotosPicker(
                selection: $selectedItems,
                maxSelectionCount: 20,
                selectionBehavior: .ordered,
                matching: .images) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 15)
                            .stroke(Color(.gray), lineWidth: 1)
                            .frame(width: 100, height: 100)
                        VStack {
                            Image(systemName: "photo.badge.plus")
                                .resizable()
                                .frame(width: 40, height: 30)
                            Text("사진등록")
                                .font(.subheadline)
                        }
                        .foregroundColor(.gray)
                    }
                }
                .onChange(of: selectedItems) {
                    Task {
                        if !isRemove {
                            isLoading = true
                            defer { isLoading = false }

                            selectedImages = []
                            for selectedItem in selectedItems {
                                if let data = try? await selectedItem.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data) {
                                    selectedImages.append(image)
                                }
                            }
                        } else {
                            isRemove = false
                        }
                    }
                }

            ScrollView(.horizontal) {
                HStack {
                    ForEach(selectedImages.indices, id: \.self) { index in
                        ZStack(alignment: .topTrailing)  {
                            Image(uiImage: selectedImages[index])
                                .resizable()
                                .scaledToFill()
                                .frame(width: 100, height: 100)
                                .cornerRadius(15)
                                .clipped()

                            Button(action: {
                                isRemove = true
                                selectedImages.remove(at: index)
                                selectedItems.remove(at: index)
                            }, label: {
                                Image(.remove)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(5)
                            })
                        }
                    }
                }
            }
        }
    }
}

struct PopUpView: View {
    var imageName: String
    var message: String

    var body: some View {
        ZStack {
            Color.black.opacity(0.5)
                .edgesIgnoringSafeArea(.all)

            RoundedRectangle(cornerRadius: 15)
                .fill(Color.white)
                .stroke(Color(.lightGray), lineWidth: 2)
                .shadow(radius: 10)
                .frame(width: 330, height: 380)

            VStack {
                Image(imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 130, height: 130)
                    .padding()

                Text(message)
                    .font(.headline)
                    .multilineTextAlignment(.center)
                    .padding()
            }
        }
    }
}
