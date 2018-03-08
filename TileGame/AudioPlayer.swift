//
//  AudioPlayer.swift
//  TileGame
//
//  Created by Andrei Luca on 11/22/15.
//  Copyright © 2015 Tile Game. All rights reserved.
//

import Foundation
import AVFoundation

class AudioPlayer {

    // MARK: Members

    fileprivate static let backgroundMusic: AVAudioPlayer = { () -> AVAudioPlayer in
        let musicPath: NSString = Bundle.main.path(forResource: "backgroundMusic", ofType: "mp3")! as NSString

        var audioPlayer: AVAudioPlayer?

        do {
            try audioPlayer = AVAudioPlayer(contentsOf: URL(fileURLWithPath: musicPath as String))
        } catch {
            fatalError("Could not create AVAudioPlayer")
        }

        return audioPlayer!
    }()

    fileprivate static let tapSound: SystemSoundID = { () -> SystemSoundID in

        let tapSoundPath: String = Bundle.main.path(forResource: "tap", ofType: "mp3")!
        let tapURL: URL = URL(fileURLWithPath: tapSoundPath)
        var tapID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(tapURL as CFURL, &tapID)

        return tapID
    }()

    fileprivate static let swipeSound: SystemSoundID = { () -> SystemSoundID in

        let swipeSoundPath: String = Bundle.main.path(forResource: "swipe", ofType: "mp3")!
        let swipeURL: URL = URL(fileURLWithPath: swipeSoundPath)
        var swipeID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(swipeURL as CFURL, &swipeID)

        return swipeID
    }()

    fileprivate static let destroySound: SystemSoundID = { () -> SystemSoundID in

        let destroySoundPath: String = Bundle.main.path(forResource: "destroy", ofType: "mp3")!
        let destroyURL: URL = URL(fileURLWithPath: destroySoundPath)
        var destroyID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(destroyURL as CFURL, &destroyID)

        return destroyID
    }()

    fileprivate static let flySound: SystemSoundID = { () -> SystemSoundID in

        let flySoundPath: String = Bundle.main.path(forResource: "fly", ofType: "mp3")!
        let flyURL: URL = URL(fileURLWithPath: flySoundPath)
        var flyID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(flyURL as CFURL, &flyID)

        return flyID
    }()


    // MARK: AudioPlayer

    deinit {
        // TODO:
//        AudioServicesDisposeSystemSoundID(<#T##inSystemSoundID: SystemSoundID##SystemSoundID#>)
    }

    // MARK: Methods

    static func isMusicOn() -> Bool {
        return AudioPlayer.backgroundMusic.isPlaying
    }

    static func play() {
        backgroundMusic.play()
    }

    static func pause() {
        backgroundMusic.pause()
    }

    static func stop() {
        backgroundMusic.stop()
    }

    static func tap() {
        if Settings.soundOn {
            AudioServicesPlaySystemSound(tapSound)
        }
    }

    static func swipe() {
        if Settings.soundOn {
            AudioServicesPlaySystemSound(swipeSound)
        }
    }

    static func destroy() {
        if Settings.soundOn {
            AudioServicesPlaySystemSound(destroySound)
        }
    }

    static func fly() {
        if Settings.soundOn {
            AudioServicesPlaySystemSound(flySound)
        }
    }

}
