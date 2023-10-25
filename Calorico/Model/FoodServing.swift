//
//  foodServing.swift
//  Calorico
//
//  Created by Dane Jensen on 10/24/23.
//

import Foundation

struct FoodServing {
    let valueDict: [String: Double] = ["1/8": 1/8, "1/4": 1/4, "1/3": 1/3, "3/8": 3/8, "1/2": 1/2, "5/8": 5/8, "2/3": 2/3, "3/4": 3/4, "7/8": 7/8]
    let unicodeDict = ["0": "0", "1/8": "215B", "1/4": "00BC", "1/3": "2153", "3/8": "215C", "1/2": "00BD", "5/8": "215D", "2/3": "2154", "3/4": "00BE", "7/8": "215E"]

    public var value: String = "1"{
        didSet {
           // print("value set to \(value)")
            if value == "-"{
                value = "0"
            }
            calculateValue()
            setString()
        }
    }
    private var lastValue = 1

    public var fraction: String = "0" {
        didSet {
            if fraction == "-"{
                fraction = "0"
            }
            // print("fraction set to \(fraction)")
            calculateValue()
            setString()
        }
    }

    public var finalValue: Double = 1.0
    public var displayString: String = "1"

    private mutating func calculateValue() {

        let valueInt = Int(self.value) ??  0
        let fracDouble = valueDict[fraction] ?? 0
        finalValue = Double(valueInt) + fracDouble
    }

    private mutating func setString() {
        let charAsString = unicodeDict[fraction] ?? "0"
        if let charCode = UInt32(charAsString, radix: 16),
           let unicode = UnicodeScalar(charCode) {
            // Create string from Unicode code point:
            let str = String(unicode)

            if value == "0" && fraction == "0" {
                displayString = "1"
                finalValue = 1
            } else if value == "0" {
                displayString = str
            } else if fraction == "0" {
                displayString = value
            } else {
                displayString = value + " " + str
            }

        } else {
                print("invalid input")
            }
        }
    }
