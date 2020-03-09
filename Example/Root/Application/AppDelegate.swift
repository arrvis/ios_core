//
//  AppDelegate.swift
//  drivers-community
//
//  Created by Yutaka Izumaru on 2019/10/01.
//  Copyright © 2019 grabss corporation. All rights reserved.
//

import SwiftEventBus
import ArrvisCore
import Firebase
import LifetimeTracker

/// AppDelegate
@UIApplicationMain final class AppDelegate: UIResponder {

    /// 共有インスタンス
    static var shared: AppDelegate {
        guard let delegate = UIApplication.shared.delegate as? AppDelegate else {
            assertionFailure()
            exit(0)
        }
        return delegate
    }

    /// Window
    var window: UIWindow?

    /// Navigator
    var navigator: BaseNavigator {
        return AppNavigator.shared
    }

    private var launchHandled = false
}

// MARK: - UIApplicationDelegate
extension AppDelegate: UIApplicationDelegate {

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
//        #if DEBUG
//            LifetimeTracker.setup(onUpdate: LifetimeTrackerDashboardIntegration(visibility: .alwaysVisible, style: .bar).refreshUI)
//        #endif
        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = AppRootViewController(navigator: navigator)
        window?.makeKeyAndVisible()

        FirebaseApp.configure()
        Messaging.messaging().delegate = FirebaseMessagingService.shared
        UserService.initService()

        if let launchOptions = launchOptions, let url = launchOptions[.url] as? URL {
            launchHandled = true
            navigator.navigate(url: url)
        } else {
            navigator.navigate(screen: AppScreens.splash)
        }
        if #available(iOS 13.0, *) {
            window!.overrideUserInterfaceStyle = .light
        }
        return true
    }

    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey: Any] = [:]) -> Bool {
        if url.scheme == navigator.scheme && !launchHandled {
            navigator.navigate(url: url)
        }
        return true
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        let badgeNumber = UIApplication.shared.applicationIconBadgeNumber
        UIApplication.shared.applicationIconBadgeNumber = 0
        UIApplication.shared.applicationIconBadgeNumber = badgeNumber
        SwiftEventBus.post(SystemBusEvents.applicationWillEnterForeground)
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        SwiftEventBus.post(SystemBusEvents.applicationDidEnterBackground)
    }

    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        completionHandler(.newData)
    }
}

/// アプリNavigator
private class AppNavigator: BaseNavigator {

    /// インスタンス
    static let shared = AppNavigator()

    // MARK: - Navigatable

    override var scheme: String {
        return Bundle.main.bundleIdentifier!
    }

    override var routes: [String] {
        return AppScreens.allCases.map {$0.rawValue}
    }

    override func getScreen(path: String) -> Screen {
        if let screen = AppScreens(rawValue: path) {
            return screen
        }
        return super.getScreen(path: path)
    }

    // MARK: - Initializer

    private override init() {
        super.init()
    }
}
