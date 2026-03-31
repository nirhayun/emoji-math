//
//  AppDelegate.swift
//  Emoji Math
//
//  Created by Nir Hayun on 17/06/2017.
//  Copyright © 2017 Nir Hayun. All rights reserved.
//

import UIKit
import FirebaseCore
import GoogleMobileAds
import AppTrackingTransparency

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var timer: Int = 0
    var bgTimer: Int = 0
    var timerWhenEnterBackground: Int = 0
    var applicationActive: Bool = true
    var bgTask: UIBackgroundTaskIdentifier = .invalid

    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        FirebaseApp.configure()
        MobileAds.shared.start { _ in
            AdManager.shared.loadAppOpenAd()
        }
        UIApplication.shared.isIdleTimerDisabled = true
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(
        _ application: UIApplication,
        configurationForConnecting connectingSceneSession: UISceneSession,
        options: UIScene.ConnectionOptions
    ) -> UISceneConfiguration {
        UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(
        _ application: UIApplication,
        didDiscardSceneSessions sceneSessions: Set<UISceneSession>
    ) {}

    // MARK: - Background / Foreground (called by SceneDelegate)

    func handleDidEnterBackground() {
        applicationActive = false
        timerWhenEnterBackground = timer
        bgTimer = 0

        let bgTimerInstance = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) { [weak self] t in
            guard let self = self else { t.invalidate(); return }
            self.bgTimer += 1
            if self.bgTimer > 500 || self.applicationActive {
                t.invalidate()
                self.endBackground()
            }
        }
        RunLoop.current.add(bgTimerInstance, forMode: .common)

        bgTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackground()
        }
    }

    func handleWillEnterForeground() {
        applicationActive = true
        timerWhenEnterBackground -= bgTimer
        if timer < timerWhenEnterBackground {
            timer = timerWhenEnterBackground
        }
    }

    func requestTrackingPermission() {
        ATTrackingManager.requestTrackingAuthorization { status in
            print("Tracking authorization status: \(status.rawValue)")
        }
    }

    private func endBackground() {
        UIApplication.shared.endBackgroundTask(bgTask)
        bgTask = .invalid
    }
}
