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

    private static let backgroundMusic: AVAudioPlayer = { () -> AVAudioPlayer in
        let musicPath: NSString = NSBundle.mainBundle().pathForResource("backgroundMusic", ofType: "mp3")!

        var audioPlayer: AVAudioPlayer?

        do {
            try audioPlayer = AVAudioPlayer(contentsOfURL: NSURL(fileURLWithPath: musicPath as String))
        } catch {
            fatalError("Could not create AVAudioPlayer")
        }

        return audioPlayer!
    }()

    private static let tapSound: SystemSoundID = { () -> SystemSoundID in

        let tapSoundPath: String = NSBundle.mainBundle().pathForResource("tap", ofType: "mp3")!
        let tapURL: NSURL = NSURL(fileURLWithPath: tapSoundPath)
        var tapID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(tapURL, &tapID)

        return tapID
    }()

    private static let swipeSound: SystemSoundID = { () -> SystemSoundID in

        let swipeSoundPath: String = NSBundle.mainBundle().pathForResource("swipe", ofType: "mp3")!
        let swipeURL: NSURL = NSURL(fileURLWithPath: swipeSoundPath)
        var swipeID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(swipeURL, &swipeID)

        return swipeID
    }()

    private static let destroySound: SystemSoundID = { () -> SystemSoundID in

        let destroySoundPath: String = NSBundle.mainBundle().pathForResource("destroy", ofType: "mp3")!
        let destroyURL: NSURL = NSURL(fileURLWithPath: destroySoundPath)
        var destroyID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(destroyURL, &destroyID)

        return destroyID
    }()

    private static let flySound: SystemSoundID = { () -> SystemSoundID in

        let flySoundPath: String = NSBundle.mainBundle().pathForResource("fly", ofType: "mp3")!
        let flyURL: NSURL = NSURL(fileURLWithPath: flySoundPath)
        var flyID: SystemSoundID = 0

        AudioServicesCreateSystemSoundID(flyURL, &flyID)

        return flyID
    }()


    // MARK: AudioPlayer

    deinit {
        // TODO:
//        AudioServicesDisposeSystemSoundID(<#T##inSystemSoundID: SystemSoundID##SystemSoundID#>)
    }

    // MARK: Methods

    static func isMusicOn() -> Bool {
        return AudioPlayer.backgroundMusic.playing
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