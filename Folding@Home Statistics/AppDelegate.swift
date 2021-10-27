//
//  AppDelegate.swift
//  Folding@Home Statistics
//
//  Created by Eric Middelhove on 04.04.20.
//  Copyright © 2020 Eric Middelhove. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    var willEnterForegroundNotification: NSNotification.Name?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.

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
     
        let container = NSPersistentContainer(name: "Folding_Home_Statistics")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                
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
    
    
    func saveUsername(username: String){
        print(username)
        let context = Task(context: persistentContainer.viewContext)
        context.username = username
        saveContext()
    }
    
//    func applicationDidBecomeActive(_ application: UIApplication) {
//        print("now active")
//        let request : NSFetchRequest<Task> = Task.fetchRequest()
//        do{
//            let result = try persistentContainer.viewContext.fetch(request)
//            print(result[0].username ?? "Mööp")
//
//        }catch{
//
//        }
//    }

}

