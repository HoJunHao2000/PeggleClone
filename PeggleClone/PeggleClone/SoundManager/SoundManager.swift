//
//  SoundManager.swift
//  PeggleClone
//
//  Created by Ho Jun Hao on 1/3/24.
//

import AVFoundation

class SoundManager {
    static let instance = SoundManager()

    private var audioPlayers: [Sound: AVAudioPlayer] = [:]

    init() {
        for sound in Sound.allCases {
            if let soundURL = Bundle.main.url(forResource: sound.rawValue, withExtension: "mp3") {
                do {
                    let audioPlayer = try AVAudioPlayer(contentsOf: soundURL)
                    audioPlayers[sound] = audioPlayer
                } catch {
                    print("Error loading sound file for \(sound.rawValue): \(error.localizedDescription)")
                }
            }
        }
    }

    func playSound(_ sound: Sound, isLoop: Bool = false) {
        if let player = audioPlayers[sound] {
            guard !player.isPlaying else {
                return
            }

            player.numberOfLoops = isLoop ? -1 : 0
            player.play()
        }
    }

    func stopSound(_ sound: Sound) {
        if let player = audioPlayers[sound] {
            guard player.isPlaying else {
                return
            }

            player.stop()
        }
    }
}
