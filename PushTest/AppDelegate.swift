//
//  AppDelegate.swift
//  PushTest
//
//  Created by 선민 on 2017. 2. 12..
//  Copyright © 2017년 kuu. All rights reserved.
//

import UIKit
import UserNotifications
import AWSSNS


@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        let noticenter = UNUserNotificationCenter.current()
        noticenter.requestAuthorization(options: [.alert, .badge, .sound]) { (isDone, error) in
            print(isDone)
        }
        application.registerForRemoteNotifications()
        
        let credentialsProvider = AWSCognitoCredentialsProvider(regionType:.apNortheast2,
                                                                identityPoolId:"Your Cognito PoolId")
        
        let configuration = AWSServiceConfiguration(region:.apNortheast2, credentialsProvider:credentialsProvider)
        
        AWSServiceManager.default().defaultServiceConfiguration = configuration
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

    // MARK:
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data)
    {
        // - 디바이스 토큰을 스트링으로.
        let token = deviceToken.map{ String(format: "%02.2hhx", $0 ) }.joined()
        
        // - AWSSNS 선언.
        let client = AWSSNS.default()
        
        // - SNS에 등록된 ARN에 token을 보낼 준비를 해준다.
        guard let input = AWSSNSCreatePlatformEndpointInput() else
        {
            print ("fail")
            return
        }
        input.token = token
        input.platformApplicationArn = "Your arn apns code"
        
        // - endpoint 등록
        
        client.createPlatformEndpoint(input) { (task, error) in
            print("Create Endpoint Success");
            
        }
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error)
    {
        
    }


}

