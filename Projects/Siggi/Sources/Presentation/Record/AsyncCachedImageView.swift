//
//  AsyncCachedImageView.swift
//  Siggi
//
//  Created by 전소영 on 2025/07/12.
//

import SwiftUI
import Kingfisher

struct AsyncCachedImageView: View {
    let imageData: Data?
    let cacheKey: String
    let cornerRadius: CGFloat
    let defaultImage: (type: DefaultImageType, width: CGFloat, height: CGFloat)

    @State private var loadedImage: UIImage? = nil
    @State private var isLoading: Bool = true

    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: cornerRadius)
                .foregroundColor(isLoading ? .gray.opacity(0.3) : (loadedImage == nil ? .gray : .clear))
            Group {
                if isLoading {
                    ProgressView()
                } else if let image = loadedImage {
                    Image(uiImage: image)
                        .resizable()
                        .clipped()
                } else {
                    switch defaultImage.type {
                    case .asset(let name):
                        Image(name)
                            .resizable()
                            .frame(width: defaultImage.width, height: defaultImage.height)
                    case .systemSymbol(let name):
                        Image(systemName: name)
                            .resizable()
                            .frame(width: defaultImage.width, height: defaultImage.height)
                    }
                }
            }
        }
        .cornerRadius(cornerRadius)
        .clipped()
        .onAppear {
            fetchImage()
        }
        .onChange(of: imageData) {
            fetchImage()
        }
    }

    private func fetchImage() {
        isLoading = true
        guard let imageData = imageData else {
            loadedImage = nil
            isLoading = false
            return
        }

        KingfisherManager.shared.cache.retrieveImage(forKey: cacheKey) { result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    DispatchQueue.main.async {
                        self.loadedImage = image
                        self.isLoading = false
                    }
                } else {
                    self.loadCacheImage(from: imageData)
                }
            case .failure:
                self.loadCacheImage(from: imageData)
            }
        }
    }

    private func loadCacheImage(from imageData: Data) {
        DispatchQueue.global(qos: .userInitiated).async {
            if let image = UIImage(data: imageData) {
                KingfisherManager.shared.cache.store(image, forKey: self.cacheKey) { _ in
                    DispatchQueue.main.async {
                        self.loadedImage = image
                        self.isLoading = false
                    }
                }
            } else {
                DispatchQueue.main.async {
                    self.loadedImage = nil
                    self.isLoading = false
                }
            }
        }
    }
}
