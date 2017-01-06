//
//  AppDelegate.swift
//  FineNotifications
//
//  Created by Marin Todorov on 4/29/16.
//  Copyright © 2016 Realm Inc. All rights reserved.
//

import UIKit

func delay(seconds: UInt32, completion:@escaping ()->Void) {
    let popTime = DispatchTime.now() + Double(Int64( Double(NSEC_PER_SEC) * Double(seconds) )) / Double(NSEC_PER_SEC)
    
    DispatchQueue.main.asyncAfter(deadline: popTime) {
        completion()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let api = GitHubAPI()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        api.startFetching()
        return true
    }
}
