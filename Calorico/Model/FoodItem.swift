//
//  FoodItem.swift
//  Calorico
//
//  Created by Dane Jensen on 4/4/23.
//

import Foundation

struct OpenFoodFactsObject : Decodable {
    
    var product : product
}

struct product : Decodable {
    var product_name : String
    var image_url : String
    var nutriments : nutriments
    var serving_quantity : Double?
}

struct nutriments : Decodable {
    let carbohydrates : Double
    let fat : Double
    let proteins : Double
    let calories : Double
    
    enum CodingKeys: String, CodingKey {
            case calories = "energy-kcal"
            case fat,
             proteins,
             carbohydrates
        }
}



struct USDAFoodObject : Decodable {
    let foods : [foodItem]
}

struct foodItem : Decodable {
    let description : String
    let servingSize : Double
    let foodNutrients : [nutrients]
    
}

struct nutrients : Decodable {
    let nutrientName : String
    let value : Double
}

struct finalFoodItem {
    var serving : Double?
    var protein : Double
    var fats : Double
    var carbs : Double
    var calories : Double
    var name : String
    var servingAmount : Double
    var servingUnit : String
    var foodType : foodType
    var brandName : String?
    var servingDescription : String
    
    func printFood() {
        print("Food: \(name)")
        print("Protein: \(protein), Carbs: \(carbs), Fat: \(fats), Calories: \(calories), Serving Size: \(String(describing: serving)), Serving Amount: \(String(describing: servingAmount)), Serving Unit: \(servingUnit )")

    }
    
}
enum foodType {
    case brand, generic
}
