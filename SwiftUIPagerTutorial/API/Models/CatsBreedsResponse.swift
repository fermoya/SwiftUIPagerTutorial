//
//  CatsBreedsResponse.swift
//  SwiftUIPagerTutorial
//
//  Created by Fernando Moya de Rivas on 03/08/2020.
//

import Foundation

typealias CatsBreedsResponse = [CatsBreed]

struct CatsBreed: Decodable, Identifiable, Equatable {
    var id: String
    var name: String
    var description: String
}
