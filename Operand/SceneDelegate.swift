//
//  SceneDelegate.swift
//  Operand
//
//  Created by Nirosh Ratnarajah on 2019-09-21.
//  Copyright © 2019 Nameless Group Inc. All rights reserved.
//

import UIKit
import os

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    let app = OSLog(subsystem: "group.nameless.financials", category: "App Launch")
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        
        // Get the managed object context from the shared persistent container.
        //    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        // Create the SwiftUI view and set the context as the value for the managedObjectContext environment keyPath.
        // Add `@Environment(\.managedObjectContext)` in the views that will need the context.
        //    let contentView = ContentView().environment(\.managedObjectContext, context)
        
        
        let server: String = Bundle.main.object(forInfoDictionaryKey: "server_url") as! String
        os_log(.info, log: self.app, "Launched with server: %{public}@", server)
        logStoredUserLS()
        
        // Use a UIHostingController as window root view controller.
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)

            window.rootViewController = UINavigationController(rootViewController: TabBarVC())
            self.window = window
            window.makeKeyAndVisible()
        }
    }
    
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        if let url = URLContexts.first?.url {
            os_log(.info, log: self.app, "Login code recieved: %{public}@", url.absoluteString)
            let parsed = url.absoluteString.replacingOccurrences(of: "nglogin:", with: "")
            os_log(.info, log: self.app, "Login code recieved: %{public}@", parsed)
            tokenLS(token: parsed)
        }
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
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
        
        // Save changes in the application's managed object context when the application transitions to the background.
        (UIApplication.shared.delegate as? AppDelegate)?.saveContext()
    }
    
    
}

