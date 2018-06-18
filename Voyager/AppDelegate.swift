//
//  AppDelegate.swift
//  Voyager
//
//  Created by Garret Koontz on 5/8/18.
//  Copyright © 2018 Garret Koontz. All rights reserved.
//

import UIKit
import OAuth2
import Alamofire


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let rootViewController = (KeychainWrapper.standard.string(forKey: "deviceID") != nil) ?
        storyboard.instantiateViewController(withIdentifier: "successVC") :
        storyboard.instantiateViewController(withIdentifier: "loginVC")
        
        window?.rootViewController = rootViewController
        return true
    }
    
    open func application(_ app: UIApplication, open url: URL, options: [UIApplicationOpenURLOptionsKey : Any] = [:]) -> Bool {
        let sourceApplication: String? = options[UIApplicationOpenURLOptionsKey.sourceApplication] as? String
        if sourceApplication == "com.apple.SafariViewService" {
            NotificationCenter.default.post(name: NSNotification.Name(rawValue: LogInViewController.kSafariViewControllerCloseNotification), object: url)
        }

        return true
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        KeychainWrapper.standard.removeObject(forKey: "oauthToken")
    }
}




