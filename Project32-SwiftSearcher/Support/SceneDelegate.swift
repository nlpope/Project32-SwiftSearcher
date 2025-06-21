//  File: SceneDelegate.swift
//  Project: Project32-SwiftSearcher
//  Created by: Noah Pope on 6/3/25.

import UIKit
import CoreSpotlight


class SceneDelegate: UIResponder, UIWindowSceneDelegate
{
    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions)
    { guard let _ = (scene as? UIWindowScene) else { return } }

    
    func sceneDidDisconnect(_ scene: UIScene) {}

    
    func sceneDidBecomeActive(_ scene: UIScene) {}

    
    func sceneWillResignActive(_ scene: UIScene) { PersistenceManager.isFirstVisitStatus = true }

    
    func sceneWillEnterForeground(_ scene: UIScene) {}

    
    func sceneDidEnterBackground(_ scene: UIScene)
    { (UIApplication.shared.delegate as? AppDelegate)?.saveContext() }
    
    /** for executing methods/funcs via CoreSpotlight while app is not currently running */
    func scene(_ scene: UIScene, continue userActivity: NSUserActivity) {
        if userActivity.activityType == CSSearchableItemActionType {
            if let uniqueIdentifier = userActivity.userInfo?[CSSearchableItemActivityIdentifier] as? String {
                if let navigationController = window?.rootViewController as? UINavigationController {
                    if let homeVC = navigationController.topViewController as? HomeVC {
                        homeVC.showTutorial(Int(uniqueIdentifier)!)
                    }
                }
            }
        }
    }
}
