//
//  AppDelegate.swift
//  RxNetwork
//
//  Created by Pircate on 04/19/2018.
//  Copyright (c) 2018 Pircate. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.backgroundColor = UIColor.white
        
        let vc = UINavigationController(rootViewController: ViewController())
        window?.rootViewController = vc
        
        window?.makeKeyAndVisible()
        return true
    }
}

