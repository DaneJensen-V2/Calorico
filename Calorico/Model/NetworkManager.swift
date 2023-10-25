//
//  NetworkManager.swift
//  Calorico
//
//  Created by Dane Jensen on 4/4/23.
//

import Foundation
import CryptoKit

public class NetworkManager {

    let fatSecretClient = FatSecret()

    enum FetchError: Error {
        case notFound
        case invalidURL
    }

    let constants = Constants()

    func getFoodFromBarcode(ID: String, completion: @escaping (Result<finalFoodItem, Error>) -> Void) {

        fatSecretClient.getFoodFromBarcode(barcode: ID) { result in
            switch result {
            case .success(let barcode):
                print(barcode.food_id.value)
                if barcode.food_id.value == "0"{
                    let error = NSError(domain: "", code: 400, userInfo: [ NSLocalizedDescriptionKey: "Food not Found"])

                    completion(.failure(error))
                    break
                }
                self.fatSecretClient.getFood(id: barcode.food_id.value) { food in
                    print(food)
                    if let formattedFood = self.formatFoodItem(food: food) {
                        completion(.success(formattedFood))

                    } else {
                        let error = NSError(domain: "", code: 401, userInfo: [ NSLocalizedDescriptionKey: "Could not format result"])

                        completion(.failure(error))
                    }

                }

            case.failure(let error):
                print(error)
                completion(.failure(error))

            }
        }
    }

    func getFoodFromSearch(searchTerm: String, page: Int, completion: @escaping (Result<[finalFoodItem], Error>) -> Void) {
        let dispatchGroup = DispatchGroup()
        let dispatchQueue = DispatchQueue(label: "any-label-name")
        let dispatchSemaphore = DispatchSemaphore(value: 0)

        fatSecretClient.searchFood(name: searchTerm, page: page) { result in

            switch result {
            case .success(let foodList):
                var formattedFoods: [finalFoodItem] = []
                dispatchQueue.async {

                    for food in foodList {
                        dispatchGroup.enter()

                        formattedFoods.append(self.formatFoodItem(food: food)!) // Fix force unwrap
                        dispatchSemaphore.signal()
                        dispatchGroup.leave()
                    }
                    dispatchSemaphore.wait()

                }

                dispatchGroup.notify(queue: dispatchQueue) {

                    DispatchQueue.main.async {

                        completion(.success(formattedFoods))
                    }
                }

                break
            case.failure(let error):
                print(error)
                completion(.failure(error))

            }
        }
    }

    func getSearchAutoComplete(searchTerm: String, completion: @escaping (Result<[String], Error>) -> Void) {
        fatSecretClient.searchAutoComplete(term: searchTerm) { result in

            if !result.isEmpty {
        //        print(result)
                completion(.success(result))

            } else {
                let error = NSError(domain: "search", code: 601, userInfo: [ NSLocalizedDescriptionKey: "Search yielded no results"])

                completion(.failure(error))
            }
        }
    }

    func formatFoodItem(food: Food) -> finalFoodItem? {
        if let servings = food.servings?[0] {

            let protein = Double(servings.protein ?? "0")!
            let carbs =   Double(servings.carbohydrate ?? "0")!
            let fats =   Double(servings.fat ?? "0")!
            let calories =   Double(servings.calories ?? "0")!
            let servingSize: Double?
            let servingUnit = servings.servingUnit ?? "Item"
            if let quantity = servings.servingAmount {
                servingSize = Double(quantity)
            } else {
                servingSize = nil
            }
            let description = servings.servingDescription ?? "1 serving"
            let name = food.name

            var type: foodType
            var brand = ""

            switch food.type {
            case "Brand":
                type = .brand
                brand = food.brand ?? "None"
            case "Generic":
                type = .generic
            default:
                type = .generic
            }

            let formattedName = name.lowercased().capitalized
            return finalFoodItem(serving: servingSize, protein: protein, fats: fats, carbs: carbs, calories: calories, name: formattedName, servingAmount: servingSize ?? 1, servingUnit: servingUnit, foodType: type, brandName: brand, servingDescription: description )

        } else {
            return nil
        }

    }

}
