// AudioManager.swift / Emoji Math

import AVFoundation

final class AudioManager {
    static let shared = AudioManager()

    private var players: [String: AVAudioPlayer] = [:]

    private init() {
        setupAudioSession()
        preloadSounds()
    }

    private func setupAudioSession() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print("AudioManager: Failed to set up audio session - \(error)")
        }
    }

    private func preloadSounds() {
        let soundNames = [
            "sound.button.click",
            "sound.correct.answer",
            "sound.wrong.answer",
            "sound.out.of.time",
            "sound.pass.stage",
            "sound.fifty",
            "sound.hint",
            "sound.timer"
        ]
        for name in soundNames {
            guard let path = Bundle.main.path(forResource: name, ofType: "mp3") else { continue }
            do {
                let player = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: path))
                player.prepareToPlay()
                players[name] = player
            } catch {
                print("AudioManager: Failed to load \(name) - \(error)")
            }
        }
    }

    func play(_ soundName: String) {
        players[soundName]?.play()
    }
}
