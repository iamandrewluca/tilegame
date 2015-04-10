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
    
    var boardPositions = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: CGPointZero))
    
    let sceneWidth: CGFloat
    let sceneHeight: CGFloat
    let tileWidth: CGFloat
    var tileSpacing: CGFloat
    let boardMargin: CGFloat
    let yStart: CGFloat
    
    var boardSprite: SKSpriteNode?

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        
        sceneWidth = size.width
        sceneHeight = size.height
        
        // 6*x+5*(x/8)+2*(x/4)=deviceWidth
        // 6 tiles + 5 spaces + 2 margins = deviceWidth
        
        tileWidth = sceneWidth * 8 / 57
        tileSpacing = tileWidth / 8
        boardMargin = tileWidth / 4
        yStart = (sceneHeight - sceneWidth) / 2 + boardMargin + tileWidth / 2
        
        super.init(size: size)
        
        calculateBoardPositions()
        
        loadLevel()
        
        generateBoardBackground()
        generateBoardTiles()
        
        prepareUI()
    }
    
    func calculateBoardPositions() {
        for var i = 0; i < boardPositions.count; ++i {
            for var j = 0; j < boardPositions[i].count; ++j {
                boardPositions[i][j].x = boardMargin + tileWidth / 2 + CGFloat(j) * (tileSpacing + tileWidth)
                boardPositions[i][j].y = yStart + CGFloat(i) * (tileSpacing + tileWidth)
            }
        }
    }
    
    func loadLevel() {
        
    }
    
    func generateBoardBackground() {
        
        // here we have info about level
        
        let ratio = UIScreen.mainScreen().scale
        
        let shape = SKShapeNode(rect: CGRectMake(0, 0, tileWidth * ratio , tileWidth * ratio), cornerRadius: 10 * ratio)
        shape.fillColor = UIColor.whiteColor()
        
        let texture = self.view?.textureFromNode(shape)
        
        var boardBackground = SKNode()
        
        for row in boardPositions {
            for position in row {
                let sprite = SKSpriteNode(texture: texture, color: UIColor.whiteColor(), size: CGSizeMake(tileWidth, tileWidth))
                sprite.position = position
                boardBackground.addChild(sprite)
            }
        }
        
        let boardTexture = self.view?.textureFromNode(boardBackground)
        boardSprite = SKSpriteNode(texture: boardTexture)
        boardSprite?.position = CGPointMake(self.size.width / 2, self.size.height / 2)
    }
    
    func generateBoardTiles() {
        
    }
    
    func prepareUI() {
        
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        addChild(boardSprite!)
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
