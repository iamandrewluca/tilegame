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
    
    var boardSprite: SKSpriteNode!

    // because of NSCoding protocol
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override init(size: CGSize) {
        super.init(size: size)
    }
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        loadLevel()
        generateBoardBackground()
        generateBoardTiles()
        prepareUI()
        showGame()
    }

    func loadLevel() {
        
    }
    
    func generateBoardBackground() {
        
        let gc = GameConstants.sharedInstance!
        
        // here we have info about level
        
        let boardBackground = SKNode()
        
        for row in gc.boardPositions {
            for position in row {
                let sprite = SKSpriteNode(texture: gc.tileTexture, color: UIColor.whiteColor(), size: CGSizeMake(gc.tileWidth, gc.tileWidth))
                sprite.position = position
                boardBackground.addChild(sprite)
            }
        }
        
        let boardTexture = self.view?.textureFromNode(boardBackground)
        
        boardSprite = SKSpriteNode(texture: boardTexture)
        boardSprite.position = CGPointMake(gc.sceneWidth / 2, gc.sceneHeight / 2)
    }
    
    func generateBoardTiles() {
        
    }
    
    func prepareUI() {
        
    }
    
    func showGame() {
        addChild(boardSprite!)
    }
}
