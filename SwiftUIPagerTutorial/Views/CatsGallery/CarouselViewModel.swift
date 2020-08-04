//
//  CarouselViewModel.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import Foundation
import SwiftUI
import Combine

class CarouselViewModel: ObservableObject {

    @Published private var catsSearchReponse: CatsSearchResponse = []
    private let apiClient = APIClient()
    private var page = 0
    private let limit = 5
    private var bag = Set<AnyCancellable>()
    private var isRequesting = false

    var imageUrls: [URL] {
        catsSearchReponse.compactMap { URL(string: $0.url) }
    }

    init() {
        fetchItems()
    }

    func reset() {
        catsSearchReponse = []
        page = 0
        isRequesting = false
    }

    func fetchItems(breedId: String? = nil, categoryId: String? = nil) {
        guard !isRequesting else { return }
        isRequesting = true
        let cancellable = apiClient
            .send(.search(page: page, limit: limit, apiKey: APIClient.key, breedId: breedId, categoryId: categoryId))
            .receive(on: DispatchQueue.main)
            .handleEvents(receiveOutput: { [unowned self] _ in
                self.page = self.page + 1
                self.isRequesting = false
            })
            .map { [unowned self] in
                self.catsSearchReponse + $0
            }
            .assign(to: \.catsSearchReponse, on: self)
        bag.insert(cancellable)
    }

}
