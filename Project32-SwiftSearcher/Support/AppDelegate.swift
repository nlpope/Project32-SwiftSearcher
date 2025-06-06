//  File: AppDelegate.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {



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
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Project32_SwiftSearcher")
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

//-------------------------------------//
// MARK: - NOTES SECTION

/**
 swift @ version: 6 (released 09.17.2024)
 iOS @ version: 18.5 (released 05.14.2025)
 xcode @ version: 16.3 (released 03.31.2025)
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 PROBLEM TRACKING:
 * = problem
 >  = solution
 
 * (NOTE: METHOD NO LONGER EXISTS, BUT STILL RELEVANT) Persistence Mgr. > updateProjectsWith() - having trouble understanding closure syntax in persistence mgr funcs
 > I get it - the SSError? in the below sig is referring to the parameter you'll play with in the '{' after calling 'updateProjectsWith...' - so yes, it's what you'll play with (the parameter[s]) once it's done - where i was getting stumped is in thinking that (SSError?) -> Void referred to what saveProjects() had to be, but think of it instead as saveProjects() spitting out the parameter you'll be playing with (SSError?) when 'updatProjectsWith...' is done - see below:
 
 COMPLETIONHANDLER IN SIGNATURE = "I EXPECT 'SAVE()' TO SPIT OUT AN SSERROR OR NIL & GIVE IT BACK TO ME FOR USE IN MY COMPLETION CLOSURE"
 completionHandler(saveProjects(projects))
 note how you only want to do something with the error it spits out if saving is unsuccessful
 
 --------------------------

 * 1st prob - kept looping between sending empty array as completion to not reading array at all (nil)
 > Kept saying CodingKey could not be found - this happened after I changed SSProject model's 'subTitle' prop to 'subtitle' so it read nil there on the fetch
 > I just used the defaults.removeObjectForKey... method to delete what was in the OG key & took it out
 > then I changed the keyname in my constants slightly to 'start fresh'
 > still ran into problems but I'm thinking it was in regards to the below as the error msgs changed
 * 2nd prob - kept getting nil when attempting to update diffable datasource
 > it's cause you had not yet called its config method in either the VDL or the VWAppear (either of which will work but now I prefer the VDL to keep it out of the logolauncher
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 TECHNOLOGIES USED / LEARNED:
 * Swift
 * Swift Keychain Wrapper
 * Google Apps Script - converts shpreadsheets into useable APIs
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 HORNS-TO-TOOT::
 * Instead of creating only the first 8 projects from scratch to load into the tableview as Paul Hudson instructs, I've constructed a Project model that holds / loads a project's title, subtitle, index, and skillset to be decoded via an api call (see next horn)
 * I created a fully functional API for the hacking with swift website's project list page using Google's App Script to pull values from a spreadsheet I wrote myself; Allowing me to fetch the projects from a consistent source without having to create, store, update the datasource then save to the persistence manager every load for values that will never differ.
 * Added a search feature using a diffable datasource, requiring me to make the SSProject model both hashable and codable
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 REFERENCES & CREDITS:
 * KeychainOptions.swift & SwiftKeychainWrapper by MIT's James Blair on 4/24/16.
 * API creation via google sheets
 > YT: https://dev.to/varshithvhegde/easy-way-to-create-your-own-api-for-free-1mbc
 * Solve for keyboard blocking textfield (by SwiftArcade)
 > YT: https://www.youtube.com/watch?v=O4tP7egAV1I&ab_channel=SwiftArcade
 > GitHub: https://github.com/jrasmusson/ios-professional-course/blob/main/Password-Reset/7-Dealing-Keyboards/README.md
 --------------------------
 XXXXXXXXXXXXXXXXXXXXXXXX
 --------------------------
 */
