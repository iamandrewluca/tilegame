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

    static let primaryFont: String = "HelveticaNeue-UltraLight"
    static let secondaryFont: String = "HelveticaNeue-CondensedBold"

    // MARK: Colors
    
    // this will be set from user preferences
    static var tilesTheme: Int { return 0 }
    static var gameTheme: Int { return 0 }
    
    // MARK: Tiles Themes

    private static let tilesColors: [[UIColor]] = [[
            UIColor(red: 219/255, green: 51/255, blue: 64/255, alpha: 1.0),
            UIColor(red: 232/255, green: 183/255, blue: 26/255, alpha: 1.0),
            UIColor(red: 247/255, green: 234/255, blue: 200/255, alpha: 1.0),
            UIColor(red: 31/255, green: 218/255, blue: 154/255, alpha: 1.0),
            UIColor(red: 40/255, green: 171/255, blue: 227/255, alpha: 1.0)
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

    // MARK: Theme Color

    // Light Colors
    // Dark Colors
    private static let gameColors: [[UIColor]] = [[
            UIColor(red: 247/255, green: 247/255, blue: 239/255, alpha: 1.0), // Tone 1
            UIColor(red: 206/255, green: 190/255, blue: 173/255, alpha: 1.0), // Tone 2
            UIColor(red: 189/255, green: 174/255, blue: 156/255, alpha: 1.0), // Tone 3
            UIColor(red: 123/255, green: 109/255, blue: 99/255, alpha: 1.0), // Tone 4
            UIColor(red: 49/255, green: 36/255, blue: 25/255, alpha: 1.0) // Tone 5
        ], [
            UIColor(red: 49/255, green: 36/255, blue: 25/255, alpha: 1.0),
            UIColor(red: 156/255, green: 146/255, blue: 132/255, alpha: 1.0),
            UIColor(red: 132/255, green: 121/255, blue: 107/255, alpha: 1.0),
            UIColor(red: 123/255, green: 109/255, blue: 99/255, alpha: 1.0),
            UIColor(red: 247/255, green: 247/255, blue: 239/255, alpha: 1.0)
        ]
    ]

    static var backgroundColor: UIColor { return gameColors[gameTheme][0] }
    static var textColor: UIColor { return gameColors[gameTheme][4] }
    static var navigationBackgroundColor: UIColor { return gameColors[gameTheme][2] }
    static var headerBackgroundColor: UIColor { return gameColors[gameTheme][1] }
    static var cellBackgroundColor: UIColor { return UIColor.whiteColor() }
    static var cellTextColor: UIColor { return darkColor }
    static var tileBackgroundColor: UIColor { return UIColor.whiteColor() }
    static var navigationButtonColor: UIColor { return gameColors[gameTheme][1] }
    static var starColor: UIColor { return UIColor.yellowColor() }
    static var noStarColor: UIColor { return UIColor.blackColor() }
    static var overlayColor: UIColor { return UIColor.brownColor() }
    static var menuBackgroundColor: UIColor { return navigationButtonColor }
    static var menuButtonColor: UIColor { return navigationBackgroundColor }

    static var lightColor: UIColor { return gameColors[0][0] }
    static var darkColor: UIColor { return gameColors[1][0] }

    // MARK: Other Colors

    static let orangeColor = UIColor(red: 255/255, green: 126/255, blue: 0/255, alpha: 1.0)
    static let yellowColor = UIColor(red: 255/255, green: 255/255, blue: 0/255, alpha: 1.0)
}