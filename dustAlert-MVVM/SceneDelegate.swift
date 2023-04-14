//
//  SceneDelegate.swift
//  dustAlert-MVVM
//
//  Created by 이주상 on 2023/04/13.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        
        window = UIWindow(windowScene: windowScene)
        window?.backgroundColor = .black
        let tabBarVC = UITabBarController()
        let vc1 = UINavigationController(rootViewController: MyZoneViewController())
        let vc2 = UINavigationController(rootViewController: AllZoneViewController())
        let vc3 = UINavigationController(rootViewController: LikeZoneViewController())
        let vc4 = UINavigationController(rootViewController: DangerZoneViewController())
        vc1.title = Const.Title.myZone
        vc2.title = Const.Title.allZone
        vc3.title = Const.Title.favorite
        vc4.title = Const.Title.dangerZone
        tabBarVC.setViewControllers([vc1, vc2, vc3, vc4], animated: true)
        tabBarVC.modalPresentationStyle = .fullScreen
        tabBarVC.tabBar.unselectedItemTintColor = .white
        tabBarVC.tabBar.backgroundColor = Const.Color.tabBarBg
        tabBarVC.tabBar.tintColor = .yellow
        guard let tabBarItems = tabBarVC.tabBar.items else { return }
        tabBarItems[0].image = UIImage(systemName: "house")
        tabBarItems[1].image = UIImage(systemName: "map")
        tabBarItems[2].image = UIImage(systemName: "bookmark")
        tabBarItems[3].image = UIImage(systemName: "exclamationmark.triangle.fill")
        
        window?.rootViewController = tabBarVC
        window?.makeKeyAndVisible()
    }
}

