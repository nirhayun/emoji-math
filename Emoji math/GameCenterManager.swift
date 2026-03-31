// GameCenterManager.swift / Emoji Math

import GameKit
import UIKit

final class GameCenterManager {
    static let shared = GameCenterManager()

    private init() {}

    var isAuthenticated: Bool {
        GKLocalPlayer.local.isAuthenticated
    }

    func authenticate(from viewController: UIViewController, completion: (() -> Void)? = nil) {
        GKLocalPlayer.local.authenticateHandler = { [weak viewController] loginVC, error in
            if let loginVC = loginVC, let presenter = viewController {
                presenter.present(loginVC, animated: true, completion: nil)
            }
            if let error = error {
                print("GameCenterManager: Auth error - \(error.localizedDescription)")
            }
            completion?()
        }
    }

    func reportScore(_ score: Int64, leaderboardIDs: [String]) {
        guard isAuthenticated else { return }
        for id in leaderboardIDs {
            GKLeaderboard.submitScore(Int(score), context: 0, player: GKLocalPlayer.local, leaderboardIDs: [id]) { error in
                if let error = error {
                    print("GameCenterManager: Failed to report score to \(id) - \(error.localizedDescription)")
                }
            }
        }
    }

    func showLeaderboard(from viewController: UIViewController) {
        guard isAuthenticated else {
            authenticate(from: viewController)
            return
        }
        let gcVC = GKGameCenterViewController(state: .leaderboards)
        gcVC.gameCenterDelegate = viewController as? GKGameCenterControllerDelegate
        viewController.present(gcVC, animated: true)
    }
}
