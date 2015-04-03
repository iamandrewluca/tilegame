//
//  GameScene.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit
import Foundation

class GameScene: SKScene {
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        //self.anchorPoint = CGPointMake(0.5, 0.5)
        
        let deviceWidth = UIScreen.mainScreen().bounds.width
        let deviceHeight = UIScreen.mainScreen().bounds.height
        
        let tileWidth = deviceWidth * 6 / 43
        let tileMargin = tileWidth / 6
        
        let shape = SKShapeNode(rect: CGRectMake(0, 0, tileWidth, tileWidth), cornerRadius: 10)
        shape.fillColor = UIColor.whiteColor()
        
        let texture = self.view?.textureFromNode(shape)
        
        let yStart = (deviceHeight - deviceWidth) / 2 + tileMargin + tileWidth / 2
        
        for i in 0...5 {
            for j in 0...5 {
                let sprite = SKSpriteNode(texture: texture)
                
                let x = tileMargin + tileWidth / 2 + CGFloat(j) * (tileMargin + tileWidth)
                let y = yStart + CGFloat(i) * (tileMargin + tileWidth)
                
                sprite.position = CGPointMake(x, y)
                
                addChild(sprite)
            }
        }
    }
    
    override func touchesBegan(touches: NSSet, withEvent event: UIEvent) {
        /* Called when a touch begins */
        
        for touch: AnyObject in touches {
            //
        }
    }
    
    override func touchesEnded(touches: NSSet, withEvent event: UIEvent) {
        // ended
    }
    
    override func touchesCancelled(touches: NSSet!, withEvent event: UIEvent!) {
        // canceled
    }
    
    override func touchesMoved(touches: NSSet, withEvent event: UIEvent) {
        // moved
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
    }
}
