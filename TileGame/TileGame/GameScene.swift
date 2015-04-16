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
    
    var boardBackground: SKSpriteNode!
    var tileNodes = SKNode()
    var tilesBoard: [[Tile?]] = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: Tile?.None))
    
    var currentLevel: Level!
    // will be used when switching from one level to another
    var newLevel: Level!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        prepareBoard()
        prepareUI()
        showGame()
    }
    
    func prepareBoard() {
        
        let backgroundNodes = SKNode()
        
        for var i = 0; i < Constants.boardPositions.count; ++i {
            for var j = 0; j < Constants.boardPositions[i].count; ++j {
                
                let currentTileType: TileType! = currentLevel.mainTiles[i][j]
                
                // check if this position is not a hole in board )
                if currentTileType != TileType.Unknown {
                
                    // add board background tile
                    let sprite = SKSpriteNode(texture: Constants.tileTexture, color: UIColor.whiteColor(), size: Constants.tileSize)
                    sprite.position = Constants.boardPositions[i][j]
                    backgroundNodes.addChild(sprite)
                    
                    // check if is a color tile
                    // we know that a star can't be a main tile
                    if currentTileType != TileType.Empty {
                        
                        let currentTile = Tile(tileRow: i, tileColumn: j, tileType: currentTileType, delegate: self)
                        
                        let childTileType: TileType! = currentLevel.childTiles[i][j]
                        
                        // checking if has a valid child
                        if childTileType != TileType.Unknown && childTileType != TileType.Empty {
                            let currentChildTile = Tile(tileRow: i, tileColumn: j, tileType: childTileType, delegate: self)
                            currentTile.childTile = currentChildTile
                        }
                        
                        tilesBoard[i][j] = currentTile
                        
                        tileNodes.addChild(currentTile)
                    }
                }
            }
        }
        
        let boardTexture = self.view?.textureFromNode(backgroundNodes)
        boardBackground = SKSpriteNode(texture: boardTexture)
        boardBackground.position = CGPointMake(Constants.sceneSize.width / 2, Constants.sceneSize.height / 2)
    }
    
    func prepareUI() {
        
    }
    
    func showGame() {
        addChild(boardBackground)
        addChild(tileNodes)
    }
}
