//
//  Settings.swift
//  TileGame
//
//  Created by Andrei Luca on 4/3/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class Settings {

    // MARK: NSUserDefaults Settings Keys

    private static let SETTINGS_SOUND_KEY: String = "SETTINGS_SOUND_KEY"
    private static let SETTINGS_MUSIC_KEY: String = "SETTINGS_MUSIC_KEY"
    private static let SETTINGS_LIGHT_THEME_KEY: String = "SETTINGS_LIGHT_THEME_KEY"
    private static let SETTINGS_ADS_KEY: String = "SETTINGS_ADS_KEY"

    // MARK: Members

    private(set) static var soundOn: Bool = { () -> Bool in
        return Settings.getBoolSettings(Settings.SETTINGS_SOUND_KEY)
    }()

    private(set) static var musicOn: Bool = { () -> Bool in
        return Settings.getBoolSettings(Settings.SETTINGS_MUSIC_KEY)
    }()

    private(set) static var lightTheme: Bool = { () -> Bool in
        return Settings.getBoolSettings(Settings.SETTINGS_LIGHT_THEME_KEY)
    }()

    private(set) static var adsOn: Bool = { () -> Bool in
        return Settings.getBoolSettings(Settings.SETTINGS_ADS_KEY)
    }()

    // MARK: Methods

    static func toogleSound() {
        Settings.setSound(!Settings.soundOn)
    }

    static func toogleMusic() {
        Settings.setMusic(!Settings.musicOn)
    }

    static func toogleTheme() {
        Settings.setLightTheme(!Settings.lightTheme)
    }

    private static func getBoolSettings(key: String) -> Bool {

        if let value = NSUserDefaults.standardUserDefaults().valueForKey(key) as! Bool? {
            return value
        }

        return true
    }

    private static func setBoolSettings(key: String, value: Bool) {
        NSUserDefaults.standardUserDefaults().setBool(value, forKey: key)
    }

    private static func setSound(value: Bool) {
        Settings.soundOn = value
        Settings.setBoolSettings(Settings.SETTINGS_SOUND_KEY, value: value)
    }

    private static func setMusic(value: Bool) {

        Settings.musicOn = value

        if value {
            if !AudioPlayer.isMusicOn() {
                AudioPlayer.play()
            }
        } else {
            AudioPlayer.stop()
        }

        Settings.setBoolSettings(Settings.SETTINGS_MUSIC_KEY, value: value)
    }

    private static func setLightTheme(value: Bool) {
        Settings.lightTheme = value
        Settings.setBoolSettings(Settings.SETTINGS_LIGHT_THEME_KEY, value: value)
    }

    static func setAds(value: Bool) {
        Settings.adsOn = value
        Settings.setBoolSettings(Settings.SETTINGS_ADS_KEY, value: value)
    }
}