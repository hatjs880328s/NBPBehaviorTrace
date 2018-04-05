//
//  AppDelegate.swift
//  source
//
//  Created by Noah_Shan on 2018/3/13.
//  Copyright © 2018年 Inspur. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        AOPNBPCoreManagerCenter.getInstance().startService()
        AOPEventUploadCenter.getInstance().startService()
        
        BeanDicCenter.getInstance().startService()
        
        let con = TwoViewController()
        self.window = UIWindow(frame: UIScreen.main.bounds)
        self.window?.makeKeyAndVisible()
        self.window?.rootViewController = UINavigationController(rootViewController: con)
        return true
    }


}

