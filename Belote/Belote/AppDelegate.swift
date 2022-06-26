//
//  AppDelegate.swift
//  Belote
//
//  Created by Sitora Guliamova on 18.05.2022.
//

import UIKit
import SpriteKit.SKScene

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        let controller = storyboard.instantiateInitialViewController()
        window?.rootViewController = controller
        window?.makeKeyAndVisible()

        return true
    }
    
    private var storyboard: UIStoryboard {
        enum StoryboardType: String {
            case iPhone = "MainIPhone"
            case iPad = "MainIPad"
        }
        
        switch UIDevice.current.userInterfaceIdiom {
        case .phone: return UIStoryboard(name: StoryboardType.iPhone.rawValue, bundle: nil)
        case .pad: return UIStoryboard(name: StoryboardType.iPad.rawValue, bundle: nil)
        default: fatalError()
        }
    }
}
