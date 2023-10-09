//
//  Barcode.swift
//  Calorico
//
//  Created by Dane Jensen on 9/11/23.
//

import Foundation

struct Autocomplete : Decodable {
    var suggestions : suggestion
}

struct suggestion : Decodable{
    var suggestion : [String]
    
}
