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
    var tilesBoard: [[Tile?]] = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: Tile?.None))
    
    var currentLevel: Level?
    // will be used when switching from one level to another
    var newLevel: Level?
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        generateBoardBackground()
        generateBoardTiles()
        prepareUI()
        showGame()
    }
    
    func generateBoardBackground() {
        
        // here we have info about level
        
        let boardBackground = SKNode()
        
        for row in Constants.boardPositions {
            for position in row {
                let sprite = SKSpriteNode(texture: Constants.tileTexture, color: UIColor.whiteColor(), size: Constants.tileSize)
                sprite.position = position
                boardBackground.addChild(sprite)
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
        addChild(boardSprite!)
    }
}
