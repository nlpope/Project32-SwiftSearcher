//  File: SceneDelegate.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit
import CoreSpotlight


class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
//        func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool
//        {
//            if userActivity.activityType == CSSearchableItemActionType {
//                if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
//                    if let navigationController = window?.rootViewController as? UINavigationController {
//                        if let homeVC = navigationController.topViewController as? HomeVC {
//                            print("scenedelegate spotlight activated!!!")
//                            homeVC.showTutorial(Int(uniqueIdentifier)!)
//                        }
//                    }
//                }
//            }
//            
//            return true
//        }

        guard let _ = (scene as? UIWindowScene) else { return }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) { PersistenceManager.isFirstVisitStatus = true }

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene)
    { (UIApplication.shared.delegate as? AppDelegate)?.saveContext() }

    func application(_ application: UIApplication, continue userActivity: NSUserActivity, restorationHandler: @escaping ([any UIUserActivityRestoring]?) -> Void) -> Bool
    {
        print("scenedelegate spotlight activated!!!")

        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                if let navigationController = window?.rootViewController as? UINavigationController {
                    if let homeVC = navigationController.topViewController as? HomeVC {
                        homeVC.showTutorial(Int(uniqueIdentifier)!)
                    }
                }
            }
        }
        
        return true
    }
}
