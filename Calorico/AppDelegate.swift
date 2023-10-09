//
//  AppDelegate.swift
//  Calorico
//
//  Created by Dane Jensen on 4/3/23.
//

import UIKit
import CoreData
import IQKeyboardManagerSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    enum Constants {
            static let apiKey = "8a70cd32aae046aab880e1a206bfe312"
            static let apiSecret = "ca559d5e668d4d89968df047a92fe58a"
        }
    
    lazy var coreDataStack: CoreDataStack = .init(modelName: "UserData")

    static let sharedAppDelegate: AppDelegate = {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            fatalError("Unexpected app delegate type, did it change? \(String(describing: UIApplication.shared.delegate))")
        }
        return delegate
    }()
    

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.\
        FatSecretCredentials.setConsumerKey(Constants.apiKey)
        FatSecretCredentials.setSharedSecret(Constants.apiSecret)
        
        
        IQKeyboardManager.shared.enable = true
        IQKeyboardManager.shared.enableAutoToolbar = false

        if(defaults.bool(forKey: "HasLaunchedOnce")) {
            print("Loading Data")
            let lastDate = (defaults.object(forKey: "lastLaunchedDate")) as! Date
            print("Last Opened: \(lastDate)")
//            let nextDay = Calendar.current.date(byAdding: .day, value: 1, to: lastDate)
        
            let lastDay = Calendar.current.dateComponents([.day], from: lastDate)
            let currentDay = Calendar.current.dateComponents([.day], from: Date.now)

            
            print(lastDay.day!)
            print(currentDay.day!)

            let currentDate = Date.now
            print("Current Date: \(currentDate)")
            defaults.set(Date.now, forKey: "lastLaunchedDate")

            if lastDay != currentDay
            {
                
                print("It is a different day.")
                
                //currentUser?.dailyFood = []
                newDay = true
            }

        } else {
          // This is the first launch ever
            print("First time launching")

            defaults.set(true, forKey: "HasLaunchedOnce")
            defaults.set(0, forKey: "calories")
            defaults.set(0, forKey: "protein")
            defaults.set(0, forKey: "carbs")
            defaults.set(0, forKey: "fat")
            
            defaults.set(Date.now, forKey: "lastLaunchedDate")
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Calorico")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }

}

