//
//  Barcode.swift
//  Calorico
//
//  Created by Dane Jensen on 9/11/23.
//

import Foundation

// swiftlint:disable type_name

struct Autocomplete: Decodable {
    var suggestions: suggestion
}

struct suggestion: Decodable {
    var suggestion: [String]

}
// swiftlint:enable type_name
