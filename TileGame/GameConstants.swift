//
//  swift
//  TileGame
//
//  Created by Andrei Luca on 14/04/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class GameConstants {
    
    static var sharedInstance: GameConstants?
    
    var boardPositions = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: CGPointZero))
    let sceneSize: CGSize
    let tileSize: CGSize
    let tileWidth: CGFloat
    let tileSpacing: CGFloat
    let boardMargin: CGFloat
    let yStart: CGFloat
    let tileCornerRadius: CGFloat = 10.0
    
    let tileTexture: SKTexture
    
    private init(view: SKView) {
        
        sceneSize = view.frame.size
        
        // 6*x+5*(x/8)+2*(x/4)=deviceWidth
        // 6 tiles + 5 spaces + 2 margins = deviceWidth
        
        tileWidth = sceneSize.width * 8 / 57
        tileSize = CGSizeMake(tileWidth, tileWidth)
        
        tileSpacing = tileWidth / 8
        boardMargin = tileWidth / 4
        yStart = (sceneSize.height - sceneSize.width) / 2 + boardMargin + tileWidth / 2
        
        // Creating texture for tile from shape
        
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
    
    class func createInstance(view: SKView) {
        if let instance = GameConstants.sharedInstance {
            println("Instance already created")
        } else {
            sharedInstance = GameConstants(view: view)
        }
    }
    
    func calculateBoardPositions() {
        
        for var i = 0; i < boardPositions.count; ++i {
            for var j = 0; j < boardPositions[i].count; ++j {
                boardPositions[i][j].x = boardMargin + tileWidth / 2 + CGFloat(j) * (tileSpacing + tileWidth)
                boardPositions[i][j].y = yStart + CGFloat(i) * (tileSpacing + tileWidth)
            }
        }
    }
}
