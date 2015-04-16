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
        
        // here we have info about level
        
        let boardBackground = SKNode()
        
        for row in Constants.boardPositions {
            for position in row {
                let sprite = SKSpriteNode(texture: Constants.tileTexture, color: UIColor.whiteColor(), size: Constants.tileSize)
                sprite.position = position
                boardBackground.addChild(sprite)
                
                var tile = Tile(tileRow: 3, tileColumn: 0, tileType: TileType.Color1, delegate: self)
                addChild(tile)
            }
        }
        
        let boardTexture = self.view?.textureFromNode(boardBackground)
        
        boardSprite = SKSpriteNode(texture: boardTexture)
        boardSprite.position = CGPointMake(Constants.sceneSize.width / 2, Constants.sceneSize.height / 2)
    }
    
    func generateBoardTiles() {
        
    }
    
    func prepareUI() {
        
    }
    
    func showGame() {
        //addChild(boardSprite!)
    }
}
