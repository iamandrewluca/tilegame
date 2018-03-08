//
//  Constants.swift
//  TileGame
//
//  Created by Andrei Luca on 4/3/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Constants {

    // MARK: Device

    static let screenSize: CGSize = UIScreen.mainScreen().bounds.size
    static let screenRatio: CGFloat = UIScreen.mainScreen().scale + 2
    static let isIphone: Bool = (UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Phone) ? true : false

    // MARK: Fonts

    static let primaryFont: String = "Comfortaa"
    static let secondaryFont: String = "Comofortaa-Light"
    static let thirdFont: String = "Comfortaa-Bold"

    // MARK: Colors

    static let redColor: SKColor = SKColor(red: 213/255, green: 83/255, blue: 102/255, alpha: 1.0)
    static let orangeColor: SKColor = SKColor(red: 241/255, green: 94/255, blue: 67/255, alpha: 1.0)
    static let yellowColor: SKColor = SKColor(red: 246/255, green: 209/255, blue: 44/255, alpha: 1.0)
    static let blueColor: SKColor = SKColor(red: 99/255, green: 124/255, blue: 189/255, alpha: 1.0)
    static let cyanColor: SKColor = SKColor(red: 0/255, green: 184/255, blue: 186/255, alpha: 1.0)
    static let darkColor: SKColor = SKColor(red: 47/255, green: 47/255, blue: 47/255, alpha: 1.0)
    static let lightColor: SKColor = SKColor(red: 254/255, green: 242/255, blue: 242/255, alpha: 1.0)

    // this will be set from user preferences
    static var tilesTheme: Int { return 0 }

    private static let tilesColors: [[UIColor]] = [[
            Constants.redColor,
            Constants.orangeColor,
            Constants.yellowColor,
            Constants.blueColor,
            Constants.cyanColor
        ], [
            UIColor(red: 105/255, green: 210/255, blue: 231/255, alpha: 1.0),
            UIColor(red: 167/255, green: 219/255, blue: 219/255, alpha: 1.0),
            UIColor(red: 224/255, green: 228/255, blue: 204/255, alpha: 1.0),
            UIColor(red: 243/255, green: 134/255, blue: 48/255, alpha: 1.0),
            UIColor(red: 250/255, green: 105/255, blue: 0/255, alpha: 1.0)
        ]
    ]

    static var Color1: UIColor { return tilesColors[tilesTheme][0] }
    static var Color2: UIColor { return tilesColors[tilesTheme][1] }
    static var Color3: UIColor { return tilesColors[tilesTheme][2] }
    static var Color4: UIColor { return tilesColors[tilesTheme][3] }
    static var Color5: UIColor { return tilesColors[tilesTheme][4] }

    // MARK: Game Theme Color

    static var textColor: UIColor { return (Settings.lightThemeOn ? darkColor : lightColor) }
    static var backgroundColor: UIColor { return (Settings.lightThemeOn ? lightColor : darkColor) }

    static var allStarsCellBackgroundColor: UIColor { return (Settings.lightThemeOn ? orangeColor : lightColor) }
    static var allStarsTextColor: UIColor { return (Settings.lightThemeOn ? lightColor : darkColor) }

}