//
//  AppDelegate.swift
//  PageView
//
//  Created by 51desk on 2017/11/28.
//  Copyright © 2017年 hxw. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow.init(frame: UIScreen.main.bounds)
        window?.makeKeyAndVisible()
        window?.backgroundColor = UIColor.white
        let pageCrl = PageViewController()
        pageCrl.titleAry = ["股份","安师大","安师大点撒","阿婶","额外","我","俄文","饿问问","热热","股份","安师大","安师大点撒","阿婶","额外"]
        var crlNameAry = [String]()
        for (_, _) in pageCrl.titleAry.enumerated() {
            crlNameAry.append("TestViewController")
        }
        pageCrl.crlNameAry = crlNameAry
        let naviCrl = UINavigationController (rootViewController: pageCrl)
        window?.rootViewController = naviCrl
        
        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.

    
    
    
    
    
    
    
    
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

