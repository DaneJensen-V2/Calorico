//
//  Barcode.swift
//  Calorico
//
//  Created by Dane Jensen on 9/11/23.
//

import Foundation
// swiftlint:disable type_name

struct SearchResults: Decodable {
    var foods_search: foods_search
}

struct foods_search: Decodable {
    var max_results: String
    var page_number: String
    var results: foodList
}

struct foodList: Decodable {
    var food: [Food]
}
// swiftlint:enable type_name
