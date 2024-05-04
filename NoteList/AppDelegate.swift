//
//  AppDelegate.swift
//  NoteList
//
//  Created by @suonvicheakdev on 28/4/24.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
//        window = UIWindow(frame: UIScreen.main.bounds)
//        window?.rootViewController = TestNotesViewController(nibName: "TestNotesViewController", bundle: nil)
//        window?.makeKeyAndVisible()
        
        //global style
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .orange
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
            
            let barAppearance = UITabBarAppearance()
            barAppearance.configureWithDefaultBackground()
            barAppearance.backgroundColor = .green
            
            let barAppearance1 = UITabBarAppearance()
            barAppearance1.configureWithDefaultBackground()
            barAppearance1.backgroundColor = .orange
            
            UITabBar.appearance().standardAppearance = barAppearance
            if #available(iOS 15.0, *) {
                UITabBar.appearance().scrollEdgeAppearance = barAppearance1
            }
        }
        
        if let tabBarController = window?.rootViewController as? UITabBarController {
            tabBarController.selectedIndex = 0
        }
        
        return true
    }

}

