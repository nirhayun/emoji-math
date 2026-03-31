//
//  SplashScreen.swift
//  Emoji math
//
//  Created by Nir Hayun on 07/04/2018.
//  Copyright © 2018 Nir Hayun. All rights reserved.
//

import UIKit

final class SplashScreen: UIViewController {

    @IBOutlet private weak var tipLabel: UILabel!

    private static let tips = [
        "Extended hold on the corresponding hint button to see how many hints you have remaining",
        "The more consecutive days you log in the more rewards you will receive",
        "A secret reset button will appear when you click the 'About' button",
        "Once a question appears, the exit button will remain available for 4 to 10 seconds",
        "Graphics and visual effects will improve as you move up in rank",
        "To make some quick calculation notes, tap the notebook bar below the answers",
        "To view a question while writing on the notepad, click the eye icon on the bottom left of the notepad",
        "Use hints when you are about to run out of time, feel lost or just want to make the question easier",
        "Login on a daily basis and collect new rewards every day"
    ]

    private static let minimumDisplayTime: TimeInterval = 1.5
    private static let maximumDisplayTime: TimeInterval = 5.0

    private var adLoadResolved = false
    private var minimumTimeElapsed = false
    private var didTransition = false

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tipLabel.text = Self.tips.randomElement()!
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        AdManager.shared.loadInterstitial(
            onLoaded: { [weak self] in
                self?.adLoadResolved = true
                self?.transitionIfReady()
            },
            onLoadFailed: { [weak self] in
                self?.adLoadResolved = true
                self?.transitionIfReady()
            }
        )
        AdManager.shared.loadRewarded()

        Timer.scheduledTimer(withTimeInterval: Self.minimumDisplayTime, repeats: false) { [weak self] _ in
            self?.minimumTimeElapsed = true
            self?.transitionIfReady()
        }

        Timer.scheduledTimer(withTimeInterval: Self.maximumDisplayTime, repeats: false) { [weak self] _ in
            self?.minimumTimeElapsed = true
            self?.adLoadResolved = true
            self?.transitionIfReady()
        }
    }

    private func transitionIfReady() {
        guard !didTransition else { return }
        guard minimumTimeElapsed && adLoadResolved else { return }

        didTransition = true
        presentMainMenu()
    }

    private func presentMainMenu() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "StartScreen") as! StartScreen
        vc.modalPresentationStyle = .fullScreen
        present(vc, animated: true)
    }
}
