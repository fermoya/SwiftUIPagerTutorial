//
//  AsyncImage.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import SwiftUI
import Combine
import Foundation

class ImageLoader: ObservableObject {

    @Published var image: UIImage?

    private let url: URL
    private var cancellable: AnyCancellable?
    private var cache: ImageCache?

    init(url: URL, cache: ImageCache? = nil) {
        self.url = url
        self.cache = cache
    }

    func load() {
        if let image = cache?[url] {
            self.image = image
            return
        }

        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .handleEvents(receiveOutput: { [weak self] in self?.cache($0) })
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }

    private func cache(_ image: UIImage?) {
        image.map { cache?[url] = $0 }
    }

    func cancel() {
        cancellable?.cancel()
    }
}

protocol ImageCache {
    subscript(_ url: URL) -> UIImage? { get set }
}

struct TemporaryImageCache: ImageCache {
    private let cache = NSCache<NSURL, UIImage>()

    subscript(_ key: URL) -> UIImage? {
        get { cache.object(forKey: key as NSURL) }
        set { newValue == nil ? cache.removeObject(forKey: key as NSURL) : cache.setObject(newValue!, forKey: key as NSURL) }
    }
}

struct ImageCacheKey: EnvironmentKey {
    static let defaultValue: ImageCache = TemporaryImageCache()
}

extension EnvironmentValues {
    var imageCache: ImageCache {
        get { self[ImageCacheKey.self] }
        set { self[ImageCacheKey.self] = newValue }
    }
}

struct AsyncImage<Placeholder: View>: View {
    @ObservedObject private var loader: ImageLoader
    private let placeholder: Placeholder?
    private var imageSize: CGSize?

    init(url: URL, placeholder: Placeholder? = nil, cache: ImageCache? = nil) {
        loader = ImageLoader(url: url, cache: cache)
        self.placeholder = placeholder
        loader.load()
    }

    var body: some View {
        Group {
            if loader.image != nil {
                if let imageSize = self.imageSize {
                    Image(uiImage: loader.image!)
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: imageSize.width, height: imageSize.height)
                        .clipped()
                } else {
                    Image(uiImage: loader.image!)
                        .resizable()
                }
            } else {
                placeholder
            }
        }
    }

    public func imageSize(_ value: CGSize) -> some View {
        var newSelf = self
        newSelf.imageSize = value
        return newSelf
    }
}
