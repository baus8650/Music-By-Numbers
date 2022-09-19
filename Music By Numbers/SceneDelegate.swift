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
        
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        let tabBarVC = UITabBarController()
        let vc1 = UINavigationController(rootViewController: SavedItemsTableViewController())
        let vc2 = UINavigationController(rootViewController: MatrixTableViewController())
        let vc3 = UINavigationController(rootViewController: SetTableViewController())
        let vc4 = UINavigationController(rootViewController: SettingsTableViewController())
        vc1.title = "Library"
        vc2.title = "Matrix"
        vc3.title = "Set"
        vc4.title = "Settings"
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        tabBarVC.tabBar.items?[0].image = UIImage(systemName: "list.bullet")
        tabBarVC.tabBar.items?[1].image = UIImage(named: "matrixIcon")
        tabBarVC.tabBar.items?[2].image = UIImage(named: "setIcon")
        tabBarVC.tabBar.items?[3].image = UIImage(systemName: "gear")
        let window = UIWindow(windowScene: windowScene)
        window.rootViewController = tabBarVC
        self.window = window
        window.makeKeyAndVisible()
    }


}

