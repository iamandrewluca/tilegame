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
    
    func calculateBoardPositions() {
        
    }
    
    func loadLevel() {
        
    }
    
    func generateBoardBackground() {
        
    }
    
    func generateBoardTiles() {
        
    }
    
    func prepareUI() {
        
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        let sceneWidth = self.size.width
        let sceneHeight = self.size.height

        // 6*x+5*(x/8)+2*(x/4)=deviceWidth
        // 6 tiles + 5 spaces + 2 margins = deviceWidth
        let tileWidth = sceneWidth * 8 / 57
        let tileSpacing = tileWidth / 8
        let boardMargin = tileWidth / 4
        
        let yStart = (sceneHeight - sceneWidth) / 2 + boardMargin + tileWidth / 2
        
        let ratio = UIScreen.mainScreen().scale
        
        let shape = SKShapeNode(rect: CGRectMake(0, 0, tileWidth * ratio , tileWidth * ratio), cornerRadius: 10 * ratio)
        shape.fillColor = UIColor.whiteColor()
        
        let texture = self.view?.textureFromNode(shape)
        
        var row = Array(count: 6, repeatedValue: CGPointZero)
        var boardPositions = Array(count: 6, repeatedValue: row)
        
        var boardBackground = SKNode()
        
        
        for i in 0...5 {
            
            for j in 0...5 {
                let sprite = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSizeMake(tileWidth, tileWidth))
                
                let x = boardMargin + tileWidth / 2 + CGFloat(j) * (tileSpacing + tileWidth)
                let y = yStart + CGFloat(i) * (tileSpacing + tileWidth)
                
                sprite.position = CGPointMake(x, y)
                
                boardPositions[i][j] = sprite.position
                
                boardBackground.addChild(sprite)
            }
        }
        
        let boardTexture = self.view?.textureFromNode(boardBackground)
        let boardSprite = SKSpriteNode(texture: boardTexture)
        boardSprite.position = CGPointMake(self.size.width / 2, self.size.height / 2)
        
        addChild(boardSprite)
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
