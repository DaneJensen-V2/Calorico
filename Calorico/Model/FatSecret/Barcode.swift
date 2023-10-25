//
//  Barcode.swift
//  Calorico
//
//  Created by Dane Jensen on 9/11/23.
//

import Foundation

// swiftlint:disable type_name

struct Food_Barcode: Decodable {
    var food_id: foodID
}

struct foodID: Decodable {
    var value: String

}
// swiftlint:enable type_name
