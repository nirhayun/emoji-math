//
//  PassStage.swift
//  Emoji Math
//
//  Created by Nir Hayun on 02/01/2018.
//  Copyright © 2018 Nir Hayun. All rights reserved.
//

import UIKit
import AVFoundation
import StoreKit

final class PassStage: UIViewController {

    @IBOutlet private weak var dismissPassStageButton: UIButton!
    @IBOutlet private weak var levelLabel: UILabel!

    var currentLevel: Int = 1
    var currentTheme: String = "\"Hats\""
    var stageTimeInterval: Double = 4.0

    var interstitialAdPresented = false
    var willPresentInterstitialAd = false
    var showingCustomAd = false
    var canDismissView = true

    var saveData = SaveData()
    var buttonClickAudioPlayer = AVAudioPlayer()
    let buttonClickSound = Bundle.main.path(forResource: "sound.button.click", ofType: "mp3")
    private let vibrationGenerator = UIImpactFeedbackGenerator(style: .light)

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSounds()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !askForReview() {
            if !showingCustomAd {
                showAd()
            }
        }
        showingCustomAd = false
        levelLabel.text = "You have passed\nto stage \(currentLevel)\n \"\(currentTheme)\""
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if currentLevel % 10 != 0 {
            canDismissView = true
        }
        Timer.scheduledTimer(withTimeInterval: stageTimeInterval, repeats: false) { [weak self] _ in
            self?.closeView()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        canDismissView = false
    }

    @IBAction private func Test(_ sender: Any) {
        print("Test")
        dismiss(animated: true)
    }

    func askForReview() -> Bool {
        guard currentLevel % 10 == 0 else { return false }
        canDismissView = false
        if let scene = view.window?.windowScene {
            SKStoreReviewController.requestReview(in: scene)
        }
        return true
    }

    func initializeSounds() {
        guard let path = buttonClickSound else { return }
        do {
            buttonClickAudioPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
    }

    func vibrateAndMakeSound() {
        if saveData.isSoundOn() {
            buttonClickAudioPlayer.play()
        }
        vibrationGenerator.impactOccurred()
    }

    func closeView() {
        if interstitialAdPresented && !showingCustomAd && canDismissView {
            dismiss(animated: true)
        } else if !willPresentInterstitialAd && !showingCustomAd && canDismissView {
            dismiss(animated: true)
        }
    }

    func showAd() {
        interstitialAdPresented = false
        if AdManager.shared.isInterstitialReady {
            willPresentInterstitialAd = true
            let shown = AdManager.shared.showInterstitial(from: self, onDismissed: { [weak self] in
                self?.handleInterstitialDismissed()
            })
            if !shown {
                willPresentInterstitialAd = false
                loadInterstitialForPassStage()
            }
        } else {
            loadInterstitialForPassStage()
        }
    }

    private func loadInterstitialForPassStage() {
        AdManager.shared.loadInterstitial(
            onLoaded: { [weak self] in
                guard let self else { return }
                self.willPresentInterstitialAd = true
                let shown = AdManager.shared.showInterstitial(from: self, onDismissed: { [weak self] in
                    self?.handleInterstitialDismissed()
                })
                if !shown {
                    self.willPresentInterstitialAd = false
                    self.scheduleCustomAdFallback()
                }
            },
            onLoadFailed: { [weak self] in
                self?.scheduleCustomAdFallback()
            }
        )
    }

    private func scheduleCustomAdFallback() {
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.showCustomAd()
        }
    }

    private func handleInterstitialDismissed() {
        interstitialAdPresented = true
        willPresentInterstitialAd = false
        Timer.scheduledTimer(withTimeInterval: 3.5, repeats: false) { [weak self] _ in
            self?.closeView()
        }
    }

    func showCustomAd() {
        if !interstitialAdPresented && !willPresentInterstitialAd {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let customAd = storyBoard.instantiateViewController(withIdentifier: "CustomAd") as! CustomAd
            customAd.modalPresentationStyle = .fullScreen
            present(customAd, animated: true)
            showingCustomAd = true
            interstitialAdPresented = true
        }
    }
}
