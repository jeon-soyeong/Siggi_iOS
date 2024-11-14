//
//  RecordPlaceView.swift
//  Siggi
//
//  Created by 전소영 on 2024/10/23.
//

import SwiftUI
import Common
import PhotosUI

struct RecordPlaceView: View {
    @Environment(Router.self) private var searchRouter
    var place: Document?
    @State private var isLoading: Bool = false

    var body: some View {
        ZStack {
            VStack {
                if let place = place {
                    NavigationBar(title: place.placeName,
                                  backButtonAction: { searchRouter.popView() },
                                  rightButtonAction: { searchRouter.popToRootView() })
                    ScrollView {
                        PhotoView(isLoading: $isLoading)
                            .padding()
                    }
                }
            }

            if isLoading {
                ProgressView()
            }
        }
    }
}

#Preview {
    RecordPlaceView()
}

struct PhotoView: View {
    @State private var selectedItems: [PhotosPickerItem] = []
    @State private var selectedImages: [UIImage] = []
    @State private var selectedImagesHashes: Set<String> = []
    @State private var previousSelectedItems: [PhotosPickerItem] = []
    @Binding var isLoading: Bool

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
                        if previousSelectedItems.count < selectedItems.count {
                            isLoading = true
                            defer { isLoading = false }

                            for selectedItem in selectedItems {
                                if let data = try? await selectedItem.loadTransferable(type: Data.self),
                                   let image = UIImage(data: data),
                                   let imageHash = image.hashValue() {

                                    if !selectedImagesHashes.contains(imageHash) {
                                        selectedImages.append(image)
                                        selectedImagesHashes.insert(imageHash)
                                    }
                                }
                            }
                        }

                        let removedItems = previousSelectedItems.filter { !selectedItems.contains($0) }
                        for removedItem in removedItems {
                            if let data = try? await removedItem.loadTransferable(type: Data.self),
                               let image = UIImage(data: data),
                               let imageHash = image.hashValue() {
                                if let index = selectedImages.firstIndex(where: { $0.hashValue() == imageHash }) {
                                    selectedImages.remove(at: index)
                                    selectedImagesHashes.remove(imageHash)
                                }
                            }
                        }
                        previousSelectedItems = selectedItems
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
                                guard !isLoading else { return }

                                isLoading = true
                                DispatchQueue.main.async {
                                    let removedImage = selectedImages[index]

                                    if let removedImageHash = removedImage.hashValue() {
                                        selectedImagesHashes.remove(removedImageHash)
                                    }

                                    selectedImages.remove(at: index)
                                    selectedItems.remove(at: index)
                                    isLoading = false
                                }
                            }, label: {
                                Image(.remove)
                                    .resizable()
                                    .frame(width: 20, height: 20)
                                    .padding(5)
                            })
                            .disabled(isLoading)
                        }
                    }
                }
            }
        }
    }
}
