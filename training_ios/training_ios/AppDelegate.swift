//
//  AppDelegate.swift
//  training_ios
//
//  Created by Pham Van Thai on 15/03/2022.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    internal var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let vc = HomeViewController()
        vc.view.backgroundColor = .white
        let navi = UINavigationController(rootViewController: vc)
        navi.navigationBar.backgroundColor = .cyan
        window?.rootViewController = navi
        window?.makeKeyAndVisible()
        return true
    }




}

