//
//  AppDelegate.swift
//  LogInOut
//
//  Created by Akshay Tandel on 27/03/23.
//

import UIKit
import Firebase

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow? //  appdelegate file pachi 1 windo delete kare pachi aa define thayi
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        
        FirebaseApp.configure()
        
        //userdefail constrain file make
        //        if let loginFlag = userDafault.value(forKey: urLogin) as? Bool,
        //           loginFlag == true{
        //
        //            //print("aa",  userDafault.value(forKey: kId) as? Int)
        //            // go to welcome home page  navigation
        //            let storybord = UIStoryboard(name: "Main", bundle: nil)
        //            let home = storybord.instantiateViewController(withIdentifier: "WelcomeVC") as! WelcomeVC
        //
        //            home.strname = userDafault.value(forKey: kXyz) as? String
        //            print("xxx" , home.strname)
        //            // print("bb", home.strname)
        //            // root push / pop
        //            UIApplication.shared.windows.first?.rootViewController = home
        //            UIApplication.shared.windows.first?.makeKeyAndVisible()
        //
        //            return true
        //
        //        }else{
        //
        //            return true
        //        }
        return true
    }
    
    // MARK: UISceneSession Lifecycle
    
    //    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
    //        // Called when a new scene session is being created.
    //        // Use this method to select a configuration to create the new scene with.
    //        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    //    }
    //
    //    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
    //        // Called when the user discards a scene session.
    //        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
    //        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    //    }
    
    
}

