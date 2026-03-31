//
//  StartScreen.swift
//  Emoji Math
//
//  Created by Nir Hayun on 30/10/2017.
//  Copyright © 2017 Nir Hayun. All rights reserved.
//

import UIKit
import GameKit
import UserNotifications

final class StartScreen: UIViewController, GKGameCenterControllerDelegate {

    var score = 0
    var canDoButtonAnimations = false
    var awardsButtonsIn = false
    var rewardAdVideoCompleted = false
    let duration = 0.6
    let soundOn = UIImage(named: "start.sound.on")
    let soundOff = UIImage(named: "start.sound.off")

    var isNotificationsAllowed = false
    var saveData: SaveData = SaveData()
    var shouldEnterAboutText = true

    var interstitialAdPresented = false
    var willPresentInterstitialAd = false
    private var returningFromGameplay = false

    let vibrationGenerator = UIImpactFeedbackGenerator(style: .light)

    @IBOutlet private weak var upperGapHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var playButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var rewardButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var scoresButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var aboutTextConstraint: NSLayoutConstraint!
    @IBOutlet weak var resetButtonConstraint: NSLayoutConstraint!

    @IBOutlet weak var dailyLoginButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var loginRowButtonConstraint: NSLayoutConstraint!
    @IBOutlet weak var watchAdButtonConstraint: NSLayoutConstraint!

    @IBOutlet weak var rewardViewConstraint: NSLayoutConstraint!

    @IBOutlet weak var aboutText: UITextView!

    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var scoresButton: UIButton!
    @IBOutlet weak var aboutButton: UIButton!
    @IBOutlet weak var dailyLoginButton: UIButton!
    @IBOutlet weak var loginRowButton: UIButton!
    @IBOutlet weak var rewardAdButton: UIButton!

    @IBOutlet weak var soundButton: UIButton!

    @IBOutlet weak var rewardView: UIView!
    @IBOutlet weak var hintReward: UIImageView!
    @IBOutlet weak var numReward: UILabel!
    @IBOutlet weak var rewardText: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        initializeSounds()
        initializeScore()
        initializeButtonLocationForAnimations()
        rewardView.layer.cornerRadius = 25.0
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if saveData.getplayerLoggedInWithGameCenter() {
            GameCenterManager.shared.authenticate(from: self)
        } else if saveData.isFirstApplicationEntry() {
            requestUserPermissionForNotifications()
            GameCenterManager.shared.authenticate(from: self)
        }

        checkRewardButtons()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if returningFromGameplay {
            returningFromGameplay = false
            if saveData.getGamesPlayed() % 10 == 0 {
                interstitialAdPresented = false
                willPresentInterstitialAd = false
                view.isUserInteractionEnabled = false
                showAd()
            }
        } else if !interstitialAdPresented && !willPresentInterstitialAd && !saveData.isFirstApplicationEntry() {
            view.isUserInteractionEnabled = false
            showAd()
        } else {
            saveData.setFirstApplicationEntry(first: false)
        }
        if canDoButtonAnimations {
            createButtonsAnimations()
        }
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        if GameCenterManager.shared.isAuthenticated {
            saveData.setplayerLoggedInWithGameCenter(logged: true)
        }
    }

    override func viewSafeAreaInsetsDidChange() {
        super.viewSafeAreaInsetsDidChange()
        let proportional = upperGapHeightConstraint.multiplier * view.bounds.height
        let needed = view.safeAreaInsets.top
        upperGapHeightConstraint.constant = max(0, needed - proportional)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        aboutText.setContentOffset(.zero, animated: false)
    }

    @IBAction func Play(_ sender: Any) {
        vibrateAndMakeSound()
        setDailyNotifications()
        returningFromGameplay = true
    }

    @IBAction func rewards(_ sender: Any) {
        vibrateAndMakeSound()
        if !awardsButtonsIn {
            exitButtonsForAboutText()
            enterRewardsButtons()
            awardsButtonsIn = true
            aboutButton.setTitle("  Back", for: .normal)
            aboutButton.setImage(UIImage(named: "start.back.png"), for: .normal)
        }
    }

    @IBAction func scores(_ sender: Any) {
        vibrateAndMakeSound()
        showLeaderboard()
    }

    @IBAction func about(_ sender: Any) {
        vibrateAndMakeSound()
        if awardsButtonsIn {
            exitRewardsButtons()
            enterButtonsForAboutText()
            awardsButtonsIn = false
            aboutButton.setTitle("  About", for: .normal)
            aboutButton.setImage(UIImage(named: "start.about.png"), for: .normal)
        } else if shouldEnterAboutText {
            exitButtonsForAboutText()
            enterAboutText()
            enterResetButton()
            aboutButton.setTitle("  Back", for: .normal)
            aboutButton.setImage(UIImage(named: "start.back.png"), for: .normal)
            shouldEnterAboutText = false
        } else {
            enterButtonsForAboutText()
            exitAboutText()
            exitResetButton()
            aboutButton.setTitle("  About", for: .normal)
            aboutButton.setImage(UIImage(named: "start.about.png"), for: .normal)
            shouldEnterAboutText = true
        }
    }

    @IBAction func sound(_ sender: Any) {
        let soundStatus = !saveData.isSoundOn()
        saveData.setSoundStatus(sound: soundStatus)

        if soundStatus {
            vibrateAndMakeSound()
            soundButton.setImage(soundOn, for: .normal)
        } else {
            vibrationGenerator.impactOccurred()
            soundButton.setImage(soundOff, for: .normal)
        }
    }

    @IBAction func reset(_ sender: Any) {
        createResetAlert()
    }

    @IBAction func dailyLogin(_ sender: Any) {
        vibrateAndMakeSound()
        let today = Date().formattedDate

        let rewards = ["main.timer", "main.fifty", "main.hint"]
        let randomIndex = Int.random(in: 0..<rewards.count)

        collectReward(hintNum: 1, hintType: rewards[randomIndex], title: "\(Date().dayOfWeekName) login\nYou received")

        if rewards[randomIndex] == "main.timer" {
            saveData.setHintTimer(hint: saveData.getHintTimer() + 1)
        } else if rewards[randomIndex] == "main.fifty" {
            saveData.setHintFifty(hint: saveData.getHintFifty() + 1)
        } else {
            saveData.setHintHint(hint: saveData.getHintHint() + 1)
        }

        saveData.setLoginDate(date: today)
        disableDailyLoginButton()
    }

    @IBAction func loginRow(_ sender: Any) {
        vibrateAndMakeSound()
        let today = Date().formattedDate
        let yesterday = Date().yesterday.formattedDate

        var title = "1 day in a row\nYou received"
        if saveData.getDaysInARowLastLoginDate() == yesterday {
            saveData.setDaysInARow(days: saveData.getDaysInARow() + 1)
            title = "\(saveData.getDaysInARow()) days in a row\nYou received"
        } else {
            saveData.setDaysInARow(days: 1)
        }

        var multiplier = Int(saveData.getDaysInARow() / 7) + 1
        if multiplier > 3 {
            multiplier = 3
        }

        let rewards = ["main.timer", "main.fifty", "main.hint"]
        let randomIndex = Int.random(in: 0..<rewards.count)

        collectReward(hintNum: multiplier, hintType: rewards[randomIndex], title: title)

        if rewards[randomIndex] == "main.timer" {
            saveData.setHintTimer(hint: saveData.getHintTimer() + multiplier)
        } else if rewards[randomIndex] == "main.fifty" {
            saveData.setHintFifty(hint: saveData.getHintFifty() + multiplier)
        } else {
            saveData.setHintHint(hint: saveData.getHintHint() + multiplier)
        }

        saveData.setDaysInARowLoginDate(date: today)
        disableLoginRowButton()
    }

    @IBAction func watchAdClick(_ sender: Any) {
        vibrateAndMakeSound()
        if AdManager.shared.isRewardedReady {
            let shown = AdManager.shared.showRewarded(from: self, onReward: { [weak self] in
                self?.rewardAdVideoCompleted = true
            }, onDismissed: { [weak self] in
                self?.handleRewardAdClosed()
            })
            if !shown {
                createResetCompletedAlert(alertTitle: "Reward video AD", alertMessage: "There are no available reward video ads in your country currently, please try again later")
            }
        } else {
            createResetCompletedAlert(alertTitle: "Reward video AD", alertMessage: "There are no available reward video ads in your country currently, please try again later")
            AdManager.shared.loadRewarded()
        }
    }

    func collectReward(hintNum: Int, hintType: String, title: String) {
        rewardText.text = title
        hintReward.image = UIImage(named: hintType)
        numReward.text = "\(hintNum)"
        showRewardView()
        Timer.scheduledTimer(withTimeInterval: 3.0, repeats: false) { [weak self] _ in
            self?.hideRewardView()
        }
    }

    func requestUserPermissionForNotifications() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge], completionHandler: { [weak self] didAllow, error in
            if error != nil {
                print("Error authorzing notifications")
            } else {
                if didAllow {
                    self?.isNotificationsAllowed = true
                    print("User allowed to Push notifications")
                } else {
                    print("User did not allow to Push notifications")
                }
            }
        })
    }

    func createResetAlert() {
        let resetAlert = UIAlertController(title: "Reset", message: "Reset score, level and hints?", preferredStyle: .alert)

        resetAlert.addAction(UIAlertAction(title: "Yes", style: .default, handler: { [weak self] _ in
            guard let self else { return }
            self.saveData.resetAll()
            self.enableDailyLoginButton()
            self.enableLoginRowButton()
            self.enableRewardAdButton()
            self.createResetCompletedAlert(alertTitle: "Reset completed", alertMessage: "Your score, levels and hints have been reset")
        }))

        resetAlert.addAction(UIAlertAction(title: "No", style: .cancel, handler: { _ in }))

        present(resetAlert, animated: true, completion: nil)
    }

    func createResetCompletedAlert(alertTitle: String, alertMessage: String) {
        let resetAlert = UIAlertController(title: alertTitle, message: alertMessage, preferredStyle: .alert)

        resetAlert.addAction(UIAlertAction(title: "Ok", style: .cancel, handler: { _ in }))

        present(resetAlert, animated: true, completion: nil)
    }

    func showRewardView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.rewardViewConstraint.constant -= self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func hideRewardView() {
        UIView.animate(withDuration: 0.3, delay: 0, options: .curveEaseOut, animations: {
            self.rewardViewConstraint.constant += self.view.bounds.height
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func createButtonsAnimations() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.playButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.3, options: .curveEaseOut, animations: {
            self.rewardButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.6, options: .curveEaseOut, animations: {
            self.scoresButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.9, options: .curveEaseOut, animations: {
            self.aboutButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        canDoButtonAnimations = false
    }

    func exitButtonsForAboutText() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.playButtonConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.2, options: .curveEaseOut, animations: {
            self.rewardButtonConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.4, options: .curveEaseOut, animations: {
            self.scoresButtonConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func enterAboutText() {
        UIView.animate(withDuration: duration, delay: 0.5, options: .curveEaseOut, animations: {
            self.aboutTextConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func exitAboutText() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.aboutTextConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func enterButtonsForAboutText() {
        UIView.animate(withDuration: duration, delay: 0.1, options: .curveEaseOut, animations: {
            self.playButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.3, options: .curveEaseOut, animations: {
            self.rewardButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.5, options: .curveEaseOut, animations: {
            self.scoresButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func exitResetButton() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.resetButtonConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func enterResetButton() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.resetButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func enterRewardsButtons() {
        UIView.animate(withDuration: duration, delay: 0.5, options: .curveEaseOut, animations: {
            self.dailyLoginButtonConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.7, options: .curveEaseOut, animations: {
            self.loginRowButtonConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.9, options: .curveEaseOut, animations: {
            self.watchAdButtonConstraint.constant -= self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func exitRewardsButtons() {
        UIView.animate(withDuration: duration, delay: 0, options: .curveEaseOut, animations: {
            self.dailyLoginButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.2, options: .curveEaseOut, animations: {
            self.loginRowButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
        UIView.animate(withDuration: duration, delay: 0.4, options: .curveEaseOut, animations: {
            self.watchAdButtonConstraint.constant += self.view.bounds.width
            self.view.layoutIfNeeded()
        }, completion: nil)
    }

    func initializeSounds() {
        soundButton.setImage(saveData.isSoundOn() ? soundOn : soundOff, for: .normal)
    }

    func initializeScore() {
        score = saveData.getScore()
    }

    func initializeButtonLocationForAnimations() {
        playButtonConstraint.constant -= view.bounds.width
        scoresButtonConstraint.constant -= view.bounds.width
        rewardButtonConstraint.constant -= view.bounds.width
        aboutButtonConstraint.constant -= view.bounds.width
        aboutTextConstraint.constant += view.bounds.width
        resetButtonConstraint.constant -= view.bounds.width
        dailyLoginButtonConstraint.constant += view.bounds.width
        loginRowButtonConstraint.constant += view.bounds.width
        watchAdButtonConstraint.constant += view.bounds.width
        rewardViewConstraint.constant += view.bounds.height
        canDoButtonAnimations = true
    }

    func vibrateAndMakeSound() {
        if saveData.isSoundOn() {
            AudioManager.shared.play("sound.button.click")
        }
        vibrationGenerator.impactOccurred()
    }

    func enableDailyLoginButton() {
        dailyLoginButton.isEnabled = true
        dailyLoginButton.setImage(UIImage(named: "reward.not.claim.png"), for: .normal)
    }

    func disableDailyLoginButton() {
        dailyLoginButton.isEnabled = false
        dailyLoginButton.setImage(UIImage(named: "start.ok.png"), for: .normal)
        dailyLoginButton.imageView?.alpha = 1
    }

    func enableLoginRowButton() {
        loginRowButton.isEnabled = true
        loginRowButton.setImage(UIImage(named: "reward.not.claim.png"), for: .normal)
    }

    func disableLoginRowButton() {
        loginRowButton.isEnabled = false
        loginRowButton.setImage(UIImage(named: "start.ok.png"), for: .normal)
        loginRowButton.imageView?.alpha = 1
    }

    func enableRewardAdButton() {
        rewardAdButton.isEnabled = true
        rewardAdButton.setImage(UIImage(named: "reward.not.claim.png"), for: .normal)
    }

    func disableRewardAdButton() {
        rewardAdButton.isEnabled = false
        rewardAdButton.setImage(UIImage(named: "start.ok.png"), for: .normal)
        rewardAdButton.imageView?.alpha = 1
    }

    func enableAllButtons() {
        view.isUserInteractionEnabled = true
    }

    func checkRewardButtons() {
        let today = Date().formattedDate

        let lastLogin = saveData.getLastLoginDate()
        if today == lastLogin {
            disableDailyLoginButton()
        } else {
            enableDailyLoginButton()
        }

        let lastLoginInARow = saveData.getDaysInARowLastLoginDate()
        if today == lastLoginInARow {
            disableLoginRowButton()
        } else {
            enableLoginRowButton()
        }

        let lastRewardAdDate = saveData.getRewardAdDate()
        if today == lastRewardAdDate {
            disableRewardAdButton()
        } else {
            enableRewardAdButton()
        }
    }

    func showLeaderboard() {
        if !GameCenterManager.shared.isAuthenticated {
            GameCenterManager.shared.authenticate(from: self)
            saveData.setplayerLoggedInWithGameCenter(logged: true)
        }
        GameCenterManager.shared.showLeaderboard(from: self)
    }

    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }

    func showAd() {
        willPresentInterstitialAd = true

        if AdManager.shared.isInterstitialReady {
            presentLoadedInterstitial()
        } else {
            AdManager.shared.loadInterstitial(
                onLoaded: { [weak self] in
                    self?.presentLoadedInterstitial()
                },
                onLoadFailed: { [weak self] in
                    self?.willPresentInterstitialAd = false
                    self?.showCustomAd()
                }
            )
        }
    }

    private func presentLoadedInterstitial() {
        let shown = AdManager.shared.showInterstitial(from: self, onDismissed: { [weak self] in
            self?.interstitialAdPresented = true
            self?.willPresentInterstitialAd = false
            self?.enableAllButtons()
        })
        if !shown {
            willPresentInterstitialAd = false
            showCustomAd()
        }
    }

    func showCustomAd() {
        if !interstitialAdPresented && !willPresentInterstitialAd {
            let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
            let customAd = storyBoard.instantiateViewController(withIdentifier: "CustomAd") as! CustomAd
            customAd.modalPresentationStyle = .fullScreen
            present(customAd, animated: true, completion: nil)
            interstitialAdPresented = true
            enableAllButtons()
        }
    }

    private func handleRewardAdClosed() {
        if rewardAdVideoCompleted {
            disableRewardAdButton()
            let today = Date().formattedDate
            let rewards = ["main.timer", "main.fifty", "main.hint"]
            let randomIndex = Int.random(in: 0..<rewards.count)
            let rewardNum = 3
            collectReward(hintNum: rewardNum, hintType: rewards[randomIndex], title: "Reward video\nYou received")
            if rewards[randomIndex] == "main.timer" {
                saveData.setHintTimer(hint: saveData.getHintTimer() + rewardNum)
            } else if rewards[randomIndex] == "main.fifty" {
                saveData.setHintFifty(hint: saveData.getHintFifty() + rewardNum)
            } else {
                saveData.setHintHint(hint: saveData.getHintHint() + rewardNum)
            }
            saveData.setRewardAdDate(date: today)
        }
        rewardAdVideoCompleted = false
        AdManager.shared.loadRewarded()
    }

    func timeNotification(id: String, notificationTitle: String, notificationText: String, timeOfNotification: DateComponents) {
        let content = UNMutableNotificationContent()
        content.title = notificationTitle
        content.body = notificationText
        content.sound = UNNotificationSound.default
        content.badge = 1

        let trigger = UNCalendarNotificationTrigger(dateMatching: timeOfNotification, repeats: true)

        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)

        UNUserNotificationCenter.current().add(request) { error in
            if error != nil {
                print("Error adding notification \(id) --- \(String(describing: error))")
            }
        }
    }

    func setDailyNotifications() {
        if isNotificationsAllowed {
            timeNotification(id: "Sunday", notificationTitle: "Daily reward is waiting", notificationText: "Log in and get your daily reward", timeOfNotification: DateComponents(hour: 11, minute: 00, weekday: 1))

            timeNotification(id: "Monday", notificationTitle: "Emoji math", notificationText: "Don't forget your daily brain exercise", timeOfNotification: DateComponents(hour: 14, minute: 30, weekday: 2))

            timeNotification(id: "Tuesday", notificationTitle: "Improve your math skills", notificationText: "Log in and work on your math skills", timeOfNotification: DateComponents(hour: 11, minute: 30, weekday: 3))

            timeNotification(id: "Wednesday", notificationTitle: "Emoji math", notificationText: "Keep your brain in shape", timeOfNotification: DateComponents(hour: 10, minute: 30, weekday: 4))

            timeNotification(id: "Thursday", notificationTitle: "Emoji math", notificationText: "Don't miss your daily reward", timeOfNotification: DateComponents(hour: 12, minute: 30, weekday: 5))

            timeNotification(id: "Friday", notificationTitle: "New rewards every day", notificationText: "Log in and pick your daily reward", timeOfNotification: DateComponents(hour: 18, minute: 00, weekday: 6))

            timeNotification(id: "Saturday", notificationTitle: "Emoji math", notificationText: "Exercise your brain by solving math problems", timeOfNotification: DateComponents(hour: 13, minute: 00, weekday: 7))
        }
    }
}
