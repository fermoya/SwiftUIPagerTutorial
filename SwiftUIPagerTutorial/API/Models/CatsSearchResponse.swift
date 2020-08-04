//
//  CatsSearchResponse.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import Foundation

typealias CatsSearchResponse = [CatsSearchResult]

struct CatsSearchResult: Decodable {
    var id: String
    var url: String
}

