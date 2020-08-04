//
//  APIClient.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import Foundation
import Combine

protocol EmptyDecodable: Decodable {
    static var empty: Self { get }
}

class APIClient {

    static let key = "2bfb95f1-9300-49de-86e5-7496cde94dc7"

    func send<Element: Decodable>(_ endpoint: APIClient.Endpoint) -> AnyPublisher<Array<Element>, Never> {
        URLSession.shared
            .dataTaskPublisher(for: endpoint.urlRequest)
            .tryMap { data, _ in
                return try JSONDecoder().decode([Element].self, from: data)
            }
            .replaceError(with: [Element]())
            .eraseToAnyPublisher()
    }

}
