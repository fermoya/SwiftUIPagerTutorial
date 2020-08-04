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
    @State private var isFilterViewPresented = false
    @State private var categoryId: String?
    @State private var breedId: String?

    private let fakeUrl = URL(string: "https://www.fake.com")!

    var body: some View {
        NavigationView {
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
                    viewModel.fetchItems(breedId: breedId, categoryId: categoryId)
                }
                .edgesIgnoringSafeArea(.bottom)
            }
            .navigationBarTitle("Cats Gallery", displayMode: .inline)
            .navigationBarItems(trailing: filterButton)
        }
        .sheet(isPresented: $isFilterViewPresented,
               onDismiss: {
                viewModel.reset()
                page = 0
                viewModel.fetchItems(breedId: breedId, categoryId: categoryId)
               },
               content: {
            CatsFilterView(categoryId: $categoryId,
                           breedId: $breedId)
        })
    }

    private var isFilterSelected: Bool {
        categoryId != nil || breedId != nil
    }

    private var filterButton: some View {
        Button(action: { isFilterViewPresented.toggle() }, label: {
            Image(systemName: isFilterSelected ? "line.horizontal.3.decrease.circle.fill" : "line.horizontal.3.decrease.circle")
                .resizable()
                .frame(width: 25, height: 25)
                .padding()
                .foregroundColor(.black)
                .font(Font.body.weight(.light))
        })
    }
}

struct CatsGalleryView_Previews: PreviewProvider {
    static var previews: some View {
        CatsGalleryView()
    }
}
