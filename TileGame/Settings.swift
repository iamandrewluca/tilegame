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

    fileprivate static let SETTINGS_SOUND_KEY: String = "SETTINGS_SOUND_KEY"
    fileprivate static let SETTINGS_MUSIC_KEY: String = "SETTINGS_MUSIC_KEY"
    fileprivate static let SETTINGS_LIGHT_THEME_KEY: String = "SETTINGS_LIGHT_THEME_KEY"
    fileprivate static let SETTINGS_ADS_KEY: String = "SETTINGS_ADS_KEY"

    // MARK: Members

    fileprivate(set) static var soundOn: Bool = { () -> Bool in
        return Settings.getBoolSettings(Settings.SETTINGS_SOUND_KEY)
    }()

    fileprivate(set) static var musicOn: Bool = { () -> Bool in
        return Settings.getBoolSettings(Settings.SETTINGS_MUSIC_KEY)
    }()

    fileprivate(set) static var lightThemeOn: Bool = { () -> Bool in
        return Settings.getBoolSettings(Settings.SETTINGS_LIGHT_THEME_KEY)
    }()

    fileprivate(set) static var adsOn: Bool = { () -> Bool in
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
        Settings.setLightTheme(!Settings.lightThemeOn)
    }

    fileprivate static func getBoolSettings(_ key: String) -> Bool {

        if let value = UserDefaults.standard.value(forKey: key) as! Bool? {
            return value
        }

        return true
    }

    fileprivate static func setBoolSettings(_ key: String, value: Bool) {
        UserDefaults.standard.set(value, forKey: key)
    }

    fileprivate static func setSound(_ value: Bool) {
        Settings.soundOn = value
        Settings.setBoolSettings(Settings.SETTINGS_SOUND_KEY, value: value)
    }

    fileprivate static func setMusic(_ value: Bool) {

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

    fileprivate static func setLightTheme(_ value: Bool) {
        Settings.lightThemeOn = value
        Settings.setBoolSettings(Settings.SETTINGS_LIGHT_THEME_KEY, value: value)
    }

    static func setAds(_ value: Bool) {
        Settings.adsOn = value
        Settings.setBoolSettings(Settings.SETTINGS_ADS_KEY, value: value)
    }
}
