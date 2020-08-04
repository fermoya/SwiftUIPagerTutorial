//
//  API+Constants.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import Foundation

extension APIClient {

    private enum Header {
        static let apiKey = "x-api-key"
    }

    private enum Order: String {
        case ascendent = "ASC"
        case descendent = "DESC"
        case random = "RANDOM"
    }

    private enum ImageSize: String {
        case full
        case medium = "med"
        case small
        case thumbnail = "thumb"
    }

    enum Endpoint {

        private enum Params {
            static let page = "page"
            static let limit = "limit"
            static let order = "order"
            static let size = "size"
            static let categoryIds = "category_ids"
            static let breedId = "breed_id"
        }

        var host: String { "https://api.thecatapi.com/v1" }

        case search(page: Int, limit: Int, apiKey: String, breedId: String?, categoryId: String?)
        case categories(apiKey: String)
        case breeds(apiKey: String)

        var path: String {
            switch self {
            case .search:
                return "/images/search"
            case .categories:
                return "/categories"
            case .breeds:
                return "/breeds"
            }
        }

        var params: [URLQueryItem] {
            switch self {
            case .search(let page, let limit, _, let breedId, let categoryId):
                return [
                    URLQueryItem(name: Params.page, value: "\(page)"),
                    URLQueryItem(name: Params.limit, value: "\(limit)"),
                    URLQueryItem(name: Params.order, value: Order.ascendent.rawValue),
                    URLQueryItem(name: Params.size, value: ImageSize.full.rawValue),
                    URLQueryItem(name: Params.categoryIds, value: categoryId),
                    URLQueryItem(name: Params.breedId, value: breedId)
                ]
            case .categories, .breeds:
                return []
            }
        }

        var headers: [String: String] {
            switch self {
            case .search(_, _, let apiKey, _, _),
                 .categories(let apiKey),
                 .breeds(let apiKey):
                return [Header.apiKey: apiKey]
            }
        }

        var urlRequest: URLRequest {
            var urlComponents = URLComponents(string: host + path)!
            urlComponents.queryItems = params
            var request = URLRequest(url: urlComponents.url!)
            headers.forEach {
                request.addValue($0.value, forHTTPHeaderField: $0.key)
            }
            return request
        }

    }

}
