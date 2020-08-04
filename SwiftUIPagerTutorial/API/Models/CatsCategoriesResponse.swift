//
//  CatsCategoriesResponse.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import Foundation

typealias CatsCategoriesResponse = [CatsCategory]

struct CatsCategory: Decodable, Identifiable, Equatable {
    var id: Int
    var name: String
}
