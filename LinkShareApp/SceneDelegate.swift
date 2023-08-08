//
//  SceneDelegate.swift
//  LinkShareApp
//
//  Created by Faiz Ul Hassan on 08/08/2023.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let windowScene = scene as? UIWindowScene else { return }
        //        window = UIWindow(windowScene: windowScene)
        // Implement any necessary setup code here
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }
    
    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }
    
    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let windowScene = scene as? UIWindowScene else { return }
        window = UIWindow(windowScene: windowScene)
        if let url = URLContexts.first?.url {
            // Handle the URL here based on your app's logic
            let userDefaults = UserDefaults(suiteName: "group.com.sdsol.sharesheet")
            if let key = url.absoluteString.components(separatedBy: "=").last,
               let sharedArray = userDefaults?.object(forKey: key) as? [String: Any] {
                
                var imageArray: [CellModel] = []
                
                for (_, imageData) in sharedArray.enumerated() {
                    let key = imageData.key
                    if key == "image", let a = imageData.value as? Data {
                        let model = CellModel(image: UIImage(data: a))
                        imageArray.append(model)
                    } else if key == "URL", let urlString = imageData.value as? String, let url = URL(string: urlString) {
                        let model = CellModel(url: url)
                        imageArray.append(model)
                    }
                }
                
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let homeVC = MainViewController.instantiateVC()
                homeVC.cellItems = imageArray
                
                let navVC = storyboard.instantiateViewController(withIdentifier: "NavigationController") as! UINavigationController
                
                navVC.viewControllers = [homeVC]
                
                window?.rootViewController = navVC
                window?.makeKeyAndVisible()
            }
        }
    }
    
}

