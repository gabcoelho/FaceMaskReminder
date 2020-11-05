//
//  AppDelegate.swift
//  FaceMaskReminder
//
//  Created by Gabriela Coelho on 15/10/20.
//  Copyright © 2020 Gabriela Coelho. All rights reserved.
//

import UIKit
import CoreLocation
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow()
        
        let mainViewController = UINavigationController(rootViewController: MainViewController())
        window?.rootViewController = mainViewController
        window?.makeKeyAndVisible()
        
        return true
    }
}

