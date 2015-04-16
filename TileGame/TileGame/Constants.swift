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
    
    static var sceneView: SKView? {
        didSet {
            if let view = sceneView {
                
                sceneSize = view.frame.size
                
                // 6*x+5*(x/8)+2*(x/4)=deviceWidth
                // 6 tiles + 5 spaces + 2 margins = deviceWidth
                tileWidth = sceneSize.width * 8 / 57
                
                tileSize = CGSizeMake(tileWidth, tileWidth)
                tileSpacing = tileWidth / 8
                boardMargin = tileWidth / 4
                yStart = (sceneSize.height - sceneSize.width) / 2 + boardMargin + tileWidth / 2
                
                let ratio = UIScreen.mainScreen().scale
                let shape = SKShapeNode()
                
                shape.path = CGPathCreateWithRoundedRect(
                    CGRectMake(0, 0, tileWidth * ratio , tileWidth * ratio),
                    tileCornerRadius * ratio,
                    tileCornerRadius * ratio, nil)
                
                shape.fillColor = UIColor.whiteColor()
                
                tileTexture = view.textureFromNode(shape)
                
                calculateBoardPositions()
            }
            
        }
    }
    
    static var boardPositions = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: CGPointZero))
    static var tileTexture: SKTexture! = SKTexture()
    static var tileSize: CGSize = CGSizeZero
    static var sceneSize: CGSize = CGSizeZero
    
    private static var tileWidth: CGFloat = 0.0
    private static var tileSpacing: CGFloat = 0.0
    private static var boardMargin: CGFloat = 0.0
    private static var yStart: CGFloat = 0.0
    private static var tileCornerRadius: CGFloat = 10
    
    private static func calculateBoardPositions() {
        for var i = 0; i < boardPositions.count; ++i {
            for var j = 0; j < boardPositions[i].count; ++j {
                boardPositions[i][j].x = boardMargin + tileWidth / 2 + CGFloat(j) * (tileSpacing + tileWidth)
                boardPositions[i][j].y = yStart + CGFloat(boardPositions.count - 1 - i) * (tileSpacing + tileWidth)
            }
        }
    }
    
    
    /////////////////////
    // Color constants //
    /////////////////////
    
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