//
//  UserModel.swift
//  Calorico
//
//  Created by Dane Jensen on 4/11/23.
//

import Foundation
import UIKit
// swiftlint:disable type_name
var foodHistory: [finalFoodItem] =  []
var currentUser: User?

struct User: Codable {

    enum gender: Codable {
        case male
        case female
    }
    enum exerciseLevel: Codable {
        case sedentary
        case light
        case moderate
        case heavy
        case athlete
    }
    enum dietModel: Int, Codable {
        case cutting = -500
        case maintaining = 0
        case bulking = 500

    }

    var height: Measurement<UnitLength>
    var weight: Measurement<UnitMass>
    var age: Int
    var goals: userMacros?
    var currentValues: userMacros?
    var userExerciseLevel: exerciseLevel
    let userGender: gender
    var userDietModel: dietModel
    var dailyFood: [finalFoodItem]

    func calculateTDEE() -> Double {
        var constant = 0.0
        if self.userGender == .male {
            constant = 5.0
        } else {
            constant = -151.0
        }

        let weightComponent = 10 * weight.converted(to: UnitMass.kilograms).value
        let heighComponent = 6.25 * height.converted(to: UnitLength.centimeters).value
        let ageComponent = 5.0 * Double(age)

        var TDEE = ((weightComponent) + (heighComponent) - (ageComponent)) + constant

        TDEE *= getMultiplier()
        return TDEE
    }

    func getMultiplier() -> Double {
        switch userExerciseLevel {
        case .sedentary:
            return 1.2
        case .light:
            return 1.375
        case .moderate:
            return 1.55
        case .heavy:
            return 1.725
        case .athlete:
            return 1.9
        }
    }

    mutating func updateProgess() {
        var totalCalories = 0.0
        var totalProtein = 0.0
        var totalFat = 0.0
        var totalCarbs = 0.0

        for item in dailyFood {
           totalCalories += item.calories
            totalProtein += item.protein
            totalFat += item.fats
            totalCarbs += item.carbs
        }

        if currentValues == nil {
            currentValues = userMacros(fat: 0, protein: 0, carbs: 0, calories: 0)
        }

        currentValues?.calories = Int(totalCalories)
        currentValues?.protein = Int(totalProtein)
        currentValues?.fat = Int(totalFat)
        currentValues?.carbs = Int(totalCarbs)

    }

    mutating func updateGoals() {
        goals = calculateGoals()
    }

    func saveToCoreData() {
        do {
            // Create JSON Encoder
            let encoder = JSONEncoder()

            // Encode Note
            let data = try encoder.encode(self)

            UserDefaults.standard.set(data, forKey: "UserData")

            print("Saved User to Defaults")

        } catch {
            print("Unable to Encode User (\(error))")
        }
    }

    func calculateGoals() -> userMacros {
        let TDEE = calculateTDEE()

        let calorieGoal = Int(TDEE) + userDietModel.rawValue
        let proteinGoal = Int((0.3 * Double(calorieGoal)) / 4.0)
        let carbsGoal = Int((0.35 * Double(calorieGoal)) / 4.0)
        let fatGoal = Int((0.35 * Double(calorieGoal)) / 9.0)

        let result = userMacros(fat: fatGoal, protein: proteinGoal, carbs: carbsGoal, calories: calorieGoal)
        return result
    }

    mutating func setCurrentMacros(calories: Int, protein: Int, carbs: Int, fat: Int) {

        currentValues = userMacros(fat: fat, protein: protein, carbs: carbs, calories: calories)

        defaults.set(calories, forKey: "calories")
        defaults.set(protein, forKey: "protein")
        defaults.set(carbs, forKey: "carbs")
        defaults.set(fat, forKey: "fat")

    }

}

struct userMacros: Codable {
    var fat: Int
    var protein: Int
    var carbs: Int
    var calories: Int
}

struct food: Codable {
    let name: String
    var id = UUID()
    var date = Date()
    let macros: userMacros
}

// swiftlint:enable type_name
