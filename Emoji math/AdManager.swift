// AdManager.swift / Emoji Math

import GoogleMobileAds
import UIKit

final class AdManager: NSObject {
    static let shared = AdManager()

    private var appOpenAd: AppOpenAd?
    private var appOpenAdLoadTime: Date?
    private var lastAppOpenShowTime: Date?
    private var isShowingAppOpenAd = false

    private var interstitialAd: InterstitialAd?
    private var rewardedAd: RewardedAd?
    private var onRewardEarned: (() -> Void)?
    private var onAdDismissed: (() -> Void)?

    private override init() {
        super.init()
    }

    // MARK: - App Open

    func loadAppOpenAd() {
        guard appOpenAd == nil else { return }
        AppOpenAd.load(
            with: AppConstants.AdMob.appOpenAdUnitID,
            request: Request()
        ) { [weak self] ad, error in
            if let error {
                print("AdManager: Failed to load app open ad - \(error.localizedDescription)")
                return
            }
            self?.appOpenAd = ad
            self?.appOpenAdLoadTime = Date()
            self?.appOpenAd?.fullScreenContentDelegate = self
        }
    }

    func showAppOpenAdIfAvailable(from viewController: UIViewController) {
        guard !isShowingAppOpenAd else { return }

        if let lastShow = lastAppOpenShowTime,
           Date().timeIntervalSince(lastShow) < AppConstants.AdMob.appOpenCooldownSeconds {
            return
        }

        guard let ad = appOpenAd, !isAppOpenAdExpired else {
            appOpenAd = nil
            loadAppOpenAd()
            return
        }

        isShowingAppOpenAd = true
        lastAppOpenShowTime = Date()
        ad.present(from: viewController)
    }

    private var isAppOpenAdExpired: Bool {
        guard let loadTime = appOpenAdLoadTime else { return true }
        return Date().timeIntervalSince(loadTime) > 4 * 60 * 60
    }

    // MARK: - Interstitial

    func loadInterstitial(onLoaded: (() -> Void)? = nil, onLoadFailed: (() -> Void)? = nil) {
        InterstitialAd.load(
            with: AppConstants.AdMob.interstitialAdUnitID,
            request: Request()
        ) { [weak self] ad, error in
            let finish: () -> Void = {
                guard let self else {
                    onLoadFailed?()
                    return
                }
                if let error {
                    print("AdManager: Failed to load interstitial - \(error.localizedDescription)")
                    onLoadFailed?()
                    return
                }
                guard let ad else {
                    onLoadFailed?()
                    return
                }
                self.interstitialAd = ad
                self.interstitialAd?.fullScreenContentDelegate = self
                onLoaded?()
            }
            if Thread.isMainThread {
                finish()
            } else {
                DispatchQueue.main.async(execute: finish)
            }
        }
    }

    func showInterstitial(from viewController: UIViewController, onDismissed: (() -> Void)? = nil) -> Bool {
        guard let ad = interstitialAd else { return false }
        self.onAdDismissed = onDismissed
        ad.present(from: viewController)
        return true
    }

    var isInterstitialReady: Bool {
        interstitialAd != nil
    }

    // MARK: - Rewarded

    func loadRewarded() {
        RewardedAd.load(
            with: AppConstants.AdMob.rewardedAdUnitID,
            request: Request()
        ) { [weak self] ad, error in
            if let error = error {
                print("AdManager: Failed to load rewarded - \(error.localizedDescription)")
                return
            }
            self?.rewardedAd = ad
            self?.rewardedAd?.fullScreenContentDelegate = self
        }
    }

    func showRewarded(from viewController: UIViewController, onReward: @escaping () -> Void, onDismissed: (() -> Void)? = nil) -> Bool {
        guard let ad = rewardedAd else { return false }
        self.onRewardEarned = onReward
        self.onAdDismissed = onDismissed
        ad.present(from: viewController, userDidEarnRewardHandler: {
            onReward()
        })
        return true
    }

    var isRewardedReady: Bool {
        rewardedAd != nil
    }
}

// MARK: - FullScreenContentDelegate

extension AdManager: FullScreenContentDelegate {
    func adDidDismissFullScreenContent(_ ad: FullScreenPresentingAd) {
        if ad is AppOpenAd {
            isShowingAppOpenAd = false
            appOpenAd = nil
            loadAppOpenAd()
            return
        }
        onAdDismissed?()
        onAdDismissed = nil
        onRewardEarned = nil
        if ad is InterstitialAd {
            interstitialAd = nil
            loadInterstitial()
        } else if ad is RewardedAd {
            rewardedAd = nil
            loadRewarded()
        }
    }

    func ad(_ ad: FullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        if ad is AppOpenAd {
            isShowingAppOpenAd = false
            print("AdManager: Failed to present app open ad - \(error.localizedDescription)")
            return
        }
        print("AdManager: Failed to present ad - \(error.localizedDescription)")
        onAdDismissed?()
        onAdDismissed = nil
        onRewardEarned = nil
    }
}
