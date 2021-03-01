//
//  AppDelegate.swift
//  Renote
//
//  Created by Raheel Sayeed on 16/02/21.
//  Copyright © 2021 Medical Gear. All rights reserved.
//

import UIKit
import WidgetKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {



	func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {

		return true
	}

	// MARK: UISceneSession Lifecycle

	func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {


		return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
	}

	func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
		// Called when the user discards a scene session.
		// If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
		// Use this method to release any resources that were specific to the discarded scenes, as they will not return.
	}
	
	
	func applicationWillEnterForeground(_ application: UIApplication) {
		if #available(iOS 14.0, *) {
			//WidgetCenter.shared.reloadAllTimelines()
		} else {
			// Fallback on earlier versions
		}
	}


}

