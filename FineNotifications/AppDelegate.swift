//
//  AppDelegate.swift
//  FineNotifications
//
//  Created by Marin Todorov on 4/29/16.
//  Copyright © 2016 Realm Inc. All rights reserved.
//

import UIKit

func delay(seconds seconds: UInt32, completion:()->Void) {
    let popTime = dispatch_time(DISPATCH_TIME_NOW, Int64( Double(NSEC_PER_SEC) * Double(seconds) ))
    
    dispatch_after(popTime, dispatch_get_main_queue()) {
        completion()
    }
}

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    let api = GitHubAPI()
    
    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        api.startFetching()
        return true
    }
}