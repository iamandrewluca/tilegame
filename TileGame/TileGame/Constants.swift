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
    
    // this will be set from user preferences
    static var colorTheme = 0
    
    // could be [[SKColor]], but this way is more clear
    // foreach theme add a color to colors arrays
    static var colors1 = [SKColor(red: 112.0/255, green: 172.0/255, blue: 203.0/255, alpha: 1.0)]
    static var colors2 = [SKColor(red: 115.0/255, green: 191.0/255, blue: 144.0/255, alpha: 1.0)]
    static var colors3 = [SKColor(red: 236.0/255, green: 76.0/255, blue: 92.0/255, alpha: 1.0)]
    static var colors4 = [SKColor(red: 206.0/255, green: 108.0/255, blue: 198.0/255, alpha: 1.0)]
    static var colors5 = [SKColor(red: 247.0/255, green: 232.0/255, blue: 147.0/255, alpha: 1.0)]
    
    // swift go home you are drunk ))
    static var Color1 = colors1[colorTheme]
    static var Color2 = colors2[colorTheme]
    static var Color3 = colors3[colorTheme]
    static var Color4 = colors4[colorTheme]
    static var Color5 = colors5[colorTheme]
    
    // other colors
    static var darkYellowColor: SKColor {
        return SKColor(red: 241.0/255, green: 169.0/255, blue: 108.0/255, alpha: 1.0)
    }
    
    static var grayYellowColor: SKColor {
        return SKColor(red: 235.0/255, green: 208.0/255, blue: 173.0/255, alpha: 1.0)
    }
    
    static var menuBackgroundColor: SKColor {
        return SKColor(red: 38.0/255, green: 38.0/255, blue: 38.0/255, alpha: 1.0)
    }
    
    static var menuLabelTextColor: SKColor {
        return menuBackgroundColor
    }
    
    static var gameSceneBackgroundColor: SKColor {
        return SKColor(red: 38.0/255, green: 38.0/255, blue: 38.0/255, alpha: 1.0)
    }
    
    static var backgroundTileExistentColor: SKColor {
        return SKColor(red: 240.0/255, green: 240.0/255, blue: 240.0/255, alpha: 1.0)
    }
}