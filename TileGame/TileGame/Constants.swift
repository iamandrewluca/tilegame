//
//  Constants.swift
//  TileGame
//
//  Created by Andrei Luca on 4/3/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit
import CoreGraphics

class Constants {
    
    static var sceneView: SKView? {
        didSet {
            if let view = sceneView, scene = view.scene {
                
                sceneSize = scene.frame.size
                
                // 6*x+5*(x/8)+2*(x/4)=deviceWidth
                // 6 tiles + 5 spaces + 2 margins = deviceWidth
                tileWidth = sceneSize.width * 8 / 57
                tileWidth.roundDecimals(numberOfDecimals: 1)
                tileCornerRadius = tileWidth / 4

                tileSize = CGSizeMake(tileWidth, tileWidth)
                
                tileSpacing = tileWidth / 8
                tileSpacing.roundDecimals(numberOfDecimals: 1)
                
                boardMargin = (sceneSize.width - 6*tileWidth - 5*tileSpacing) / 2
                
                yStart = (sceneSize.height - sceneSize.width) / 2 + boardMargin + tileWidth / 2
                
                let ratio = UIScreen.mainScreen().scale
                
                let starPath = getStarPath(0, y: 0, radius: tileWidth / 4 * ratio, sides: 5, pointyness: 2)
                let roundRectPath = CGPathCreateWithRoundedRect(
                    CGRectMake(0, 0, tileWidth * ratio , tileWidth * ratio),
                    tileCornerRadius * ratio,
                    tileCornerRadius * ratio, nil)
                
                let tile2RoundCornersPath = UIBezierPath(
                    roundedRect: CGRectMake(0, 0, tileWidth * ratio, tileWidth * ratio),
                    byRoundingCorners: UIRectCorner.TopLeft | UIRectCorner.BottomRight,
                    cornerRadii: CGSizeMake(tileWidth * ratio / 2, tileWidth * ratio / 2))
                
                let tile2RoundCornersShape = SKShapeNode()
                tile2RoundCornersShape.path = tile2RoundCornersPath.CGPath
                tile2RoundCornersShape.fillColor = SKColor.whiteColor()
                tile2RoundCornersTexture = view.textureFromNode(tile2RoundCornersShape)
                
                let headerBackgroundPath = UIBezierPath(
                    roundedRect: CGRectMake(0, 0, sceneSize.width * ratio, tileWidth * ratio),
                    byRoundingCorners: UIRectCorner.TopLeft | UIRectCorner.TopRight,
                    cornerRadii: CGSizeMake(tileWidth * ratio / 2, tileWidth * ratio / 2))
                
                let headerBackgroundShape = SKShapeNode()
                headerBackgroundShape.path = headerBackgroundPath.CGPath
                headerBackgroundShape.fillColor = SKColor.whiteColor()
                headerTexture = view.textureFromNode(headerBackgroundShape)
                
                let tileShape = SKShapeNode()
                tileShape.fillColor = UIColor.whiteColor()
                tileShape.path = roundRectPath
                tileTexture = view.textureFromNode(tileShape)
                
                let starShape = SKShapeNode()
                starShape.fillColor = SKColor.whiteColor()
                starShape.path = starPath
                starTexture = view.textureFromNode(starShape)
                
                starShape.fillColor = SKColor.blackColor()
                starShape.setScale(0.75)
                starShape.zRotation = 30
                starShape.position = CGPointMake(tileShape.frame.width / 2, tileShape.frame.height / 2)
                tileShape.addChild(starShape)
                
                tileStarTexture = view.textureFromNode(tileShape)
                
                calculateBoardPositions()
                calculateHeaderPositions()
            }
        }
    }
    
    static var boardPositions = Array(count: Constants.boardSize,
        repeatedValue: Array(count: Constants.boardSize,
            repeatedValue: CGPointZero))
    
    static var headerPositions = Array(count: 5, repeatedValue: CGPointZero)
    
    static var tileTexture: SKTexture! = SKTexture()
    static var starTexture: SKTexture! = SKTexture()
    static var tileStarTexture: SKTexture! = SKTexture()
    static var tile2RoundCornersTexture: SKTexture = SKTexture()
    static var headerTexture: SKTexture = SKTexture()
    static var tileSize: CGSize = CGSizeZero
    static var sceneSize: CGSize = CGSizeZero
    static var boardSize = 6
    
    private static var tileWidth: CGFloat = 0.0
    private static var tileSpacing: CGFloat = 0.0
    private static var boardMargin: CGFloat = 0.0
    private static var yStart: CGFloat = 0.0
    private static var tileCornerRadius: CGFloat = 0.0
    
    private static func calculateBoardPositions() {
        for var i = 0; i < boardSize; ++i {
            for var j = 0; j < boardSize; ++j {
                boardPositions[i][j].x = boardMargin + tileWidth / 2 + CGFloat(j) * (tileSpacing + tileWidth)
                boardPositions[i][j].y = yStart + CGFloat(Constants.boardSize - 1 - i) * (tileSpacing + tileWidth)
            }
        }
    }
    
    private static func calculateHeaderPositions() {
        let widthWithoutLR = sceneSize.width - tileWidth * 2
        let onePart = widthWithoutLR / 6
        let startX = tileWidth + onePart
        let yMiddle = tileWidth / 2
        
        for var i = 0; i < headerPositions.count; ++i {
            headerPositions[i] = CGPointMake(startX + CGFloat(i) * onePart, yMiddle)
        }
    }
    
    static func degree2radian(a:CGFloat) -> CGFloat {
        let b = CGFloat(M_PI) * a/180
        return b
    }
    private static func polygonPointArray(sides: Int, x: CGFloat, y: CGFloat, radius: CGFloat, adjustment: CGFloat = 0) -> [CGPoint] {
        let angle = degree2radian(360/CGFloat(sides))
        let cx = x // x origin
        let cy = y // y origin
        let r  = radius // radius of circle
        var i = sides
        var points = [CGPoint]()
        while points.count <= sides {
            let xpo = cx - r * cos(angle * CGFloat(i)+degree2radian(adjustment))
            let ypo = cy - r * sin(angle * CGFloat(i)+degree2radian(adjustment))
            points.append(CGPoint(x: xpo, y: ypo))
            i--;
        }
        return points
    }
    private static func getStarPath(x: CGFloat, y: CGFloat, radius: CGFloat, sides: Int, pointyness: CGFloat) -> CGPathRef {
        let adjustment = 360/sides/2
        let path = CGPathCreateMutable()
        let points = polygonPointArray(sides, x: x, y: y, radius: radius)
        var cpg = points[0]
        let points2 = polygonPointArray(sides,x: x,y: y,radius: radius*pointyness,adjustment:CGFloat(adjustment))
        var i = 0
        CGPathMoveToPoint(path, nil, cpg.x, cpg.y)
        for p in points {
            CGPathAddLineToPoint(path, nil, points2[i].x, points2[i].y)
            CGPathAddLineToPoint(path, nil, p.x, p.y)
            i++
        }
        CGPathCloseSubpath(path)
        
        var rotaionTransform = CGAffineTransformMakeRotation(degree2radian(-54))
        return CGPathCreateCopyByTransformingPath(path, &rotaionTransform)
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