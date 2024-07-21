//
//  SoundManager.swift
//  Chubby Chowdown Sweet Delight Drop
//
//  Created by Ivan Elonov on 06.07.2024.
//

import Foundation
import AVFoundation

class SoundManager {
    static let shared = SoundManager()
    
    private var audioPlayers: [String: AVAudioPlayer] = [:]
    private var backgroundMusicPlayer: AVAudioPlayer?
    
    private init() {}
    
    func preloadSound(_ filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else { return }
        do {
            let player = try AVAudioPlayer(contentsOf: url)
            audioPlayers[filename] = player
            player.volume = 0.5
            player.prepareToPlay()
        } catch {
            print("Error loading sound: \(error.localizedDescription)")
        }
    }
    
    func stopSound(_ filename: String) {
        audioPlayers[filename]?.stop()
    }
    
    func playSound(_ filename: String) {
        stopSound(filename)
        audioPlayers[filename]?.currentTime = 0
        audioPlayers[filename]?.play()
    }
    
    func playBackgroundMusic(_ filename: String) {
        guard let url = Bundle.main.url(forResource: filename, withExtension: "wav") else { return }
        do {
            backgroundMusicPlayer = try AVAudioPlayer(contentsOf: url)
            backgroundMusicPlayer?.volume = 0.2
            backgroundMusicPlayer?.numberOfLoops = -1 // бесконечное повторение
            backgroundMusicPlayer?.play()
        } catch {
            print("Error playing background music: \(error.localizedDescription)")
        }
    }
    
    func stopBackgroundMusic() {
        backgroundMusicPlayer?.stop()
    }
    
    func pauseBackgroundMusic() {
        backgroundMusicPlayer?.pause()
    }
    
    func resumeBackgroundMusic() {
        backgroundMusicPlayer?.play()
    }
}
