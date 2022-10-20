//
//  SceneDelegate.swift
//  Music By Numbers
//
//  Created by Tim Bausch on 11/8/21.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if UserDefaults.standard.color(forKey: "MatrixCellColor") == nil {
            UserDefaults.standard.set(.blue, forKey: "MatrixCellColor")
        }
        if UserDefaults.standard.color(forKey: "CircleShapeColor") == nil {
            UserDefaults.standard.set(.blue, forKey: "CircleShapeColor")
        }
        if UserDefaults.standard.color(forKey: "AxisLineColor") == nil {
            UserDefaults.standard.set(.red, forKey: "AxisLineColor")
        }
        
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()

        // TAB BAR BACKGROUND COLOR HERE. (same as above)
        appearance.backgroundColor = UIColor(named: "tabBar")
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = UITabBar.appearance().standardAppearance
        
        window = UIWindow(frame: UIScreen.main.bounds)
        let mainVC = MatrixTableViewController()
        window?.rootViewController = mainVC
        window?.makeKeyAndVisible()
    }


}

