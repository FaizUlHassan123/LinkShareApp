//
//  AppDelegate.swift
//  LinkShareApp
//
//  Created by Faiz Ul Hassan on 08/08/2023.
//


import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
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
    
    
}

//IF you'r app version in less than 13 then you can uncomment the below code.
//extension AppDelegate {
//
//    func application(_ app: UIApplication,
//                     open url: URL,
//                     options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
//
//        let userDefaults = UserDefaults(suiteName: "group.com.sdsol.sharesheet")
//        if let key = url.absoluteString.components(separatedBy: "=").last,
//           let sharedArray = userDefaults?.object(forKey: key) as? [String:Any] {
//
//            var imageArray: [CellModel] = []
//
//            for (_,imageData) in sharedArray.enumerated() {
//                if imageData.key == "image"{
//                    let a = imageData.value as! Data
//                    let model = CellModel(image:UIImage(data: a))
//                    imageArray.append(model)
//
//                }else if  imageData.key == "URL"{
//                    // 'str' contains the decoded string
//                    if  let string = imageData.value as? String, let url = URL(string: string) {
//                        let model = CellModel(url: url)
//                        imageArray.append(model)
//                    }
//                    //                    let model = CellModel(url: url)
//                }
//
//            }
//
//            let storyboard = UIStoryboard(name: "Main", bundle: nil)
//            let homeVC = storyboard.instantiateViewController(withIdentifier: "MainViewController") as! MainViewController
//            homeVC.cellItems = imageArray
//
//            let navVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
//
//            navVC.viewControllers = [homeVC]
//            self.window?.rootViewController = navVC
//            self.window?.makeKeyAndVisible()
//
//            return true
//        }else if let key = url.absoluteString.components(separatedBy: "=").last,
//                 let sharedArray = userDefaults?.url(forKey: key) as? [Any] {
//            print("Url \(sharedArray)")
//        }
//
//        return false
//    }
//
//
//
//}
