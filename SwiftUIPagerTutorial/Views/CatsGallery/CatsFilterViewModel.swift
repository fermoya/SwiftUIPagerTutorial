//
//  CatsFilterViewModel.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import SwiftUI
import Combine

class CatsFilterViewModel: ObservableObject {

    @Published var breedsResponse: CatsBreedsResponse = [] {
        didSet {
            print(breedsResponse)
        }
    }
    @Published var categoriesResponse: CatsCategoriesResponse = []
    private var bag = Set<AnyCancellable>()

    private let apiClient = APIClient()

    init() {
        fetchCategories()
        fetchBreeds()
    }

    private func fetchCategories() {
        let cancellable = apiClient
            .send(.categories(apiKey: APIClient.key))
            .receive(on: DispatchQueue.main)
            .assign(to: \.categoriesResponse, on: self)
        bag.insert(cancellable)
    }

    private func fetchBreeds() {
        let cancellable = apiClient
            .send(.breeds(apiKey: APIClient.key))
            .handleEvents(receiveOutput: {
                print($0)
            })
            .receive(on: DispatchQueue.main)
            .assign(to: \.breedsResponse, on: self)
        bag.insert(cancellable)
    }

}
