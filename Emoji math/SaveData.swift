//
//  SaveData.swift
//  Emoji math
//
//  UserDefaults-backed persistence for scores, hints, streaks, and preferences.
//
//  Created by Nir Hayun on 17/02/2018.
//  Copyright © 2018 Nir Hayun. All rights reserved.
//

import Foundation

class SaveData {

    private let userData = UserDefaults.standard

    private enum Keys: String {
        case sound = "SOUND"
        case daysInARow = "DAYS_IN_A_ROW"
        case daysInARowLoginDate = "DAYS_IN_A_ROW_LOGIN_DATE"
        case loginDate = "LOGIN_DATE"
        case playerLevel = "PLAYER_LEVEL"
        case awardAdDate = "AWARD_AD_DATE"
        case highScore = "HIGH_SCORE"
        case bestScore = "BEST_SCORE"
        case hintHint = "HINT_HINT"
        case hintFifty = "HINT_FIFTY"
        case hintTimer = "HINT_TIMER"
        case playerLoggedWithGameCenter = "PLAYER_LOGGED_WITH_GAME_CENTER"
        case firstGameCenterLoginAttempt = "FIRST_GAME_CENTER_LOGIN_ATTEMPT"
        case gamesPlayed = "GAMES_PLAYED"
    }

    private enum Defaults {
        static let sound = true
        static let playerLevel = "Smart"
        static let loginDate = "00-00-0000"
        static let hintHintInitial = 3
        static let hintFiftyInitial = 3
        static let hintTimerInitial = 5
        static let score = 0
        static let daysInARow = 0
        static let playerLoggedWithGameCenter = false
        static let firstGameCenterLoginAttempt = true
        static let gamesPlayed = 0
    }

    init() {
        userData.register(defaults: [
            Keys.sound.rawValue: Defaults.sound,
            Keys.daysInARow.rawValue: Defaults.daysInARow,
            Keys.daysInARowLoginDate.rawValue: Defaults.loginDate,
            Keys.loginDate.rawValue: Defaults.loginDate,
            Keys.playerLevel.rawValue: Defaults.playerLevel,
            Keys.awardAdDate.rawValue: Defaults.loginDate,
            Keys.highScore.rawValue: Defaults.score,
            Keys.bestScore.rawValue: Defaults.score,
            Keys.hintHint.rawValue: Defaults.hintHintInitial,
            Keys.hintFifty.rawValue: Defaults.hintFiftyInitial,
            Keys.hintTimer.rawValue: Defaults.hintTimerInitial,
            Keys.playerLoggedWithGameCenter.rawValue: Defaults.playerLoggedWithGameCenter,
            Keys.firstGameCenterLoginAttempt.rawValue: Defaults.firstGameCenterLoginAttempt,
            Keys.gamesPlayed.rawValue: Defaults.gamesPlayed
        ])
    }

    func setLoginDate(date:String) {
        userData.set(date, forKey: Keys.loginDate.rawValue)
    }

    func getLastLoginDate() -> String {
        userData.string(forKey: Keys.loginDate.rawValue)!
    }

    func setDaysInARowLoginDate(date:String) {
        userData.set(date, forKey: Keys.daysInARowLoginDate.rawValue)
    }

    func getDaysInARowLastLoginDate() -> String {
        userData.string(forKey: Keys.daysInARowLoginDate.rawValue)!
    }

    func setDaysInARow(days:Int) {
        userData.set(days, forKey: Keys.daysInARow.rawValue)
    }

    func getDaysInARow() -> Int {
        userData.integer(forKey: Keys.daysInARow.rawValue)
    }

    func setRewardAdDate(date:String) {
        userData.set(date, forKey: Keys.awardAdDate.rawValue)
    }

    func getRewardAdDate() -> String {
        userData.string(forKey: Keys.awardAdDate.rawValue)!
    }

    func setSoundStatus(sound:Bool) {
        userData.set(sound, forKey: Keys.sound.rawValue)
    }

    func isSoundOn() -> Bool {
        userData.bool(forKey: Keys.sound.rawValue)
    }

    func setBestScore(score:Int) {
        userData.set(score, forKey: Keys.bestScore.rawValue)
    }

    func getBestScore() -> Int {
        userData.integer(forKey: Keys.bestScore.rawValue)
    }

    func setUserScore(score:Int) {
        userData.set(score, forKey: Keys.highScore.rawValue)
    }

    func getScore() -> Int {
        userData.integer(forKey: Keys.highScore.rawValue)
    }

    func setHintHint(hint:Int) {
        userData.set(min(hint, 99), forKey: Keys.hintHint.rawValue)
    }

    func getHintHint() -> Int {
        userData.integer(forKey: Keys.hintHint.rawValue)
    }

    func setHintFifty(hint:Int) {
        userData.set(min(hint, 99), forKey: Keys.hintFifty.rawValue)
    }

    func getHintFifty() -> Int {
        userData.integer(forKey: Keys.hintFifty.rawValue)
    }

    func setHintTimer(hint:Int) {
        userData.set(min(hint, 99), forKey: Keys.hintTimer.rawValue)
    }

    func getHintTimer() -> Int {
        userData.integer(forKey: Keys.hintTimer.rawValue)
    }

    func setplayerLoggedInWithGameCenter(logged:Bool) {
        userData.set(logged, forKey: Keys.playerLoggedWithGameCenter.rawValue)
    }

    func getplayerLoggedInWithGameCenter() -> Bool {
        userData.bool(forKey: Keys.playerLoggedWithGameCenter.rawValue)
    }

    func setFirstApplicationEntry(first:Bool) {
        userData.set(first, forKey: Keys.firstGameCenterLoginAttempt.rawValue)
    }

    func isFirstApplicationEntry() -> Bool {
        userData.bool(forKey: Keys.firstGameCenterLoginAttempt.rawValue)
    }

    func setPlayerLevel(level:String) {
        userData.set(level, forKey: Keys.playerLevel.rawValue)
    }

    func getPlayerLevel() -> String {
        userData.string(forKey: Keys.playerLevel.rawValue)!
    }

    func getGamesPlayed() -> Int {
        userData.integer(forKey: Keys.gamesPlayed.rawValue)
    }

    func incrementGamesPlayed() {
        userData.set(getGamesPlayed() + 1, forKey: Keys.gamesPlayed.rawValue)
    }

    func resetAll() {
        setLoginDate(date: Defaults.loginDate)
        setDaysInARowLoginDate(date: Defaults.loginDate)
        setUserScore(score: 0)
        setRewardAdDate(date: Defaults.loginDate)
        setHintFifty(hint: Defaults.hintFiftyInitial)
        setHintHint(hint: Defaults.hintHintInitial)
        setHintTimer(hint: Defaults.hintTimerInitial)
    }

}
