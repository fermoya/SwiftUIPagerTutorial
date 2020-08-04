//
//  CarouselView.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import SwiftUI
import SwiftUIPager

struct CatsGalleryView: View {

    @State private var page: Int = 0
    @Environment(\.imageCache) private var cache: ImageCache
    @StateObject private var viewModel = CarouselViewModel()

    private let fakeUrl = URL(string: "https://www.fake.com")!

    var body: some View {
        GeometryReader { proxy in
            Pager(page: $page, data: viewModel.imageUrls + [fakeUrl], id: \.absoluteURL) { url in
                if url != fakeUrl {
                    AsyncImage(url: url,
                               placeholder: Text("Loading ..."),
                               cache: cache)
                        .clipShape(RoundedRectangle(cornerRadius: 20))
                } else {
                    ProgressView()
                }
            }
            .itemSpacing(16)
            .vertical()
            .interactive(0.8)
            .alignment(.justified)
            .itemAspectRatio(16 / 9)
            .swipeInteractionArea(.allAvailable)
            .padding()
            .onPageChanged { newPage in
                guard newPage == viewModel.imageUrls.count - 1 else { return }
                viewModel.fetchItems()
            }
            .edgesIgnoringSafeArea(.all)
        }
    }
}

struct CarouselView_Previews: PreviewProvider {
    static var previews: some View {
        CatsGalleryView()
    }
}
