//
//  AppDelegate.swift
//  LiftingBuddy
//
//  Created by Logman on 6/2/19.
//  Copyright © 2019 Logman. All rights reserved.
//

import UIKit

class CustomNavigationController: UINavigationController {
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

extension UINavigationController {
    open override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        if #available(iOS 13.0, *) {
            let colorAppearance = UINavigationBarAppearance()
            colorAppearance.configureWithOpaqueBackground()
            colorAppearance.backgroundColor = .darkPurple
            colorAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
            colorAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            
            UINavigationBar.appearance().standardAppearance = colorAppearance
            UINavigationBar.appearance().scrollEdgeAppearance = colorAppearance
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().isTranslucent = false
            
        } else {
            UINavigationBar.appearance().tintColor = .white
            UINavigationBar.appearance().isTranslucent = false
            UINavigationBar.appearance().barTintColor = .darkPurple
            UINavigationBar.appearance().prefersLargeTitles = true
            UINavigationBar.appearance().titleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            UINavigationBar.appearance().largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
            
        }
  
        
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        let workoutsController = WorkoutsController()
        //        dummyViewController.view.backgroundColor = .blue
        let navController = CustomNavigationController(rootViewController: workoutsController)
        window?.rootViewController = navController
        
        return true
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }
    
    
}

