//
//  AppDelegate.swift
//  RxNetwork
//
//  Created by Pircate on 04/19/2018.
//  Copyright (c) 2018 Pircate. All rights reserved.
//

import UIKit

/// 可变参打印函数
///
/// - Parameters:
///   - items: Zero or more items to print.
///   - separator: A string to print between each item. The default is a single space (`" "`).
///   - terminator: The string to print after all items have been printed. The  default is a newline (`"\n"`).
///   - file: 文件名，默认值：#file
///   - line: 第几行，默认值：#line
///   - function: 函数名，默认值：#function
func QL1(_ items: Any?...,
    separator: String = " ",
    terminator: String = "\n",
    file: String = #file,
    line: Int = #line,
    function: String = #function) {
    #if DEBUG
    print("\((file as NSString).lastPathComponent):\(line) \(function):", terminator: separator)
    let count = items.count - 1
    for (i, item) in items.enumerated() {
        print(item ?? "nil", terminator: i == count ? terminator : separator)
    }
    #endif
}

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

