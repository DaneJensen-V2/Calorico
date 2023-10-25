//
//  Constants.swift
//  Calorico
//
//  Created by Dane Jensen on 4/3/23.
//

import Foundation
import UIKit

let defaults = UserDefaults.standard

struct Constants {

    let USDA_API_KEY = "2SO4n4kvvlzlTlrGw3xaNtK1WVKoNsQQoR3R3NNd"

    }

struct Colors {
    let darkBlueBG = UIColor(named: "MainBG")
    let lightGreen = UIColor(named: "lightGreen")
    let mainOrange = UIColor.orange
    let CalorieOrange = UIColor(named: "CalorieOrange")
    let FatGreen = UIColor(named: "FatGreen")
    let CarbsBrown = UIColor(named: "CarbsBrown")
    let ProteinRed = UIColor(named: "ProteinRed")
    let lightGray = UIColor(named: "lightGray")

}

struct Images {
    let avacado = UIImage(named: "avocado")
    let bread = UIImage(named: "bread")
    let meat = UIImage(named: "meat")
    let check = UIImage(named: "check")
    let calorie = UIImage(named: "calories")

}
