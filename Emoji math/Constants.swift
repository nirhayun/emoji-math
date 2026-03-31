// Constants.swift / Emoji Math

import Foundation

enum AppConstants {
    enum AdMob {
        #if DEBUG
        static let appOpenAdUnitID = "ca-app-pub-3940256099942544/5575463023"
        static let interstitialAdUnitID = "ca-app-pub-3940256099942544/4411468910"
        static let rewardedAdUnitID = "ca-app-pub-3940256099942544/1712485313"
        #else
        static let appOpenAdUnitID = "ca-app-pub-9345812500572194/8267135344"
        static let interstitialAdUnitID = "ca-app-pub-9345812500572194/6557528505"
        static let rewardedAdUnitID = "ca-app-pub-9345812500572194/6351418449"
        #endif

        static let appOpenCooldownSeconds: TimeInterval = 4 * 60 * 60
    }

    enum GameCenter {
        static let bestPlayers = "BSTP"
        static let lowestScores = "LWST"
        static let recentBest = "RCBP"
        static let needPractice = "NMPC"
    }

    /// Weekday: 1 = Sunday … 7 = Saturday (`Calendar` / `DateComponents.weekday`).
    enum Notifications {
        static let daily: [(id: String, title: String, body: String, hour: Int, minute: Int, weekday: Int)] = [
            ("emojimath.daily.sun", "Emoji Math", "Kick off the week with a quick puzzle streak.", 10, 0, 1),
            ("emojimath.daily.mon", "Emoji Math", "Monday math: warm up your brain in one minute.", 9, 30, 2),
            ("emojimath.daily.tue", "Emoji Math", "Tuesday challenge — beat yesterday’s score.", 12, 0, 3),
            ("emojimath.daily.wed", "Emoji Math", "Midweek mix: new emojis, same sharp mind.", 18, 0, 4),
            ("emojimath.daily.thu", "Emoji Math", "Thursday teaser waiting for you.", 19, 30, 5),
            ("emojimath.daily.fri", "Emoji Math", "Friday fun round — play before the weekend.", 17, 0, 6),
            ("emojimath.daily.sat", "Emoji Math", "Saturday session: relax and solve.", 11, 0, 7)
        ]
    }
}
