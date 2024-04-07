//
//  AppDelegate.swift
//  PetzCare
//
//  Created by Talita Albuquerque Araújo on 07/04/24.
//

import SwiftUI
import Firebase


class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        FirebaseApp.configure()
        
        return true
    }
    
//    func application(_ app: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
//        return GIDSignIn.sharedInstance.handle(url)
//    }
}

