//
//  PandaGrabApp.swift
//  PandaGrab
//
//  Created by Heng Tzemeng on 18/05/2021.
//

import SwiftUI
import Firebase

@main
struct PandaGrabApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}

class AppDelegate:NSObject,UIApplicationDelegate{
    
    func application(_ application:UIApplication,didFinishLaunchingWithOptions
                        launchOptions:[UIApplication.LaunchOptionsKey:Any]? = nil) -> Bool{
        FirebaseApp.configure()
        return true
    }
}
