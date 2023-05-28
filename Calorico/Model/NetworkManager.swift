//
//  NetworkManager.swift
//  Calorico
//
//  Created by Dane Jensen on 4/4/23.
//

import Foundation

public class NetworkManager {
    
    enum fetchError: Error {
        case notFound
        case invalidURL
    }
    
    let constants = Constants()
 
    func getFoodInfo(from barcode : String, completion: @escaping (Result<finalFoodItem, Error>) -> Void){
            
        checkUSDA(from: barcode, completion: { USDAresult in
            switch USDAresult {
            case .failure(let error):
                print(error)
                self.checkOpenFoodFacts(from: barcode, completion: { OFFresult in
                    switch OFFresult {
                    case .failure(let error):
                        completion(.failure(error))
                    case .success(let food):
                        completion(.success(self.formatOpenFoodFacts(food: food)))
                    }
                })
                
            case .success(let food):
                completion(.success(self.formatUSDA(food: food)))
              }
            })
            
          
    }
    
    func formatUSDA(food : USDAFoodObject) -> finalFoodItem{
        let protein = food.foods[0].foodNutrients[0].value
        let carbs = food.foods[0].foodNutrients[2].value
        let fats = food.foods[0].foodNutrients[1].value
        let calories = food.foods[0].foodNutrients[3].value
        let servingSize = food.foods[0].servingSize
        let name = food.foods[0].description
        
        let formattedName = name.lowercased().capitalized
        return finalFoodItem(serving: servingSize, protein: protein, fats: fats, carbs: carbs, calories: calories, name: formattedName)
        
    }
    
    func formatOpenFoodFacts(food : OpenFoodFactsObject) -> finalFoodItem{
        let protein = food.product.nutriments.proteins
        let carbs =  food.product.nutriments.carbohydrates
        let fats =  food.product.nutriments.fat
        let calories =  food.product.nutriments.calories
        let servingSize : Double?
        if let quantity = food.product.serving_quantity{
            servingSize = Double(quantity)
        }
        else {
            servingSize = nil
        }
        
        let name = food.product.product_name
        
        let formattedName = name.lowercased().capitalized
        return finalFoodItem(serving: servingSize, protein: protein, fats: fats, carbs: carbs, calories: calories, name: formattedName)
        
        
    }
    
    func checkUSDA(from ID : String, completion: @escaping (Result<USDAFoodObject, Error>) -> Void) {

        
        guard let url = URL(string: "https://api.nal.usda.gov/fdc/v1/foods/search?query=\(ID)&api_key=\(constants.USDA_API_KEY)") else{
            print("URL creation error")
            return
        }
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Unknown error", error)
                return
            }
            
            guard response != nil, let data = data else {
                return
            }
            
            if let responseObject = try? JSONDecoder().decode(USDAFoodObject.self, from: data) {
                
                if responseObject.foods.isEmpty {
                    let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "No Food Found."])
                    completion(.failure(error))

                }
                else {
                    completion(.success(responseObject))

                }
                
            } else {
                let error = NSError(domain: "", code: 404, userInfo: [ NSLocalizedDescriptionKey: "Failed."])
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
    
    func checkOpenFoodFacts(from ID : String, completion: @escaping (Result<OpenFoodFactsObject, Error>) -> Void) {
        
        guard let url = URL(string: "https://world.openfoodfacts.org/api/v2/product/\(ID)") else{
            print("URL creation error")
            return
        }
        
        let urlRequest = URLRequest(url: url)
        
        let dataTask = URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let error = error {
                completion(.failure(error))
                print("Unknown error", error)
                return
            }
            
            guard response != nil, let data = data else {
                return
            }
            
            if let responseObject = try? JSONDecoder().decode(OpenFoodFactsObject.self, from: data) {
                completion(.success(responseObject))
            } else {
                let error = NSError(domain: "com.AryamanSharda", code: 200, userInfo: [NSLocalizedDescriptionKey: "Failed"])
                completion(.failure(error))
            }
        }
        
        dataTask.resume()
    }
}

