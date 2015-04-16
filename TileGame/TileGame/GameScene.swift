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
                        
                        let currentTile = Tile(tileRow: i, tileColumn: j, tileType: currentTileType, tileDelegate: self)
                        
                        let childTileType: TileType! = currentLevel.childTiles[i][j]
                        
                        // checking if has a valid child
                        if childTileType != TileType.Unknown && childTileType != TileType.Empty {
                            let currentChildTile = Tile(tileRow: i, tileColumn: j, tileType: childTileType, tileDelegate: self)
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
    
    var startedPosition = CGPointZero
    var directionsConstrains = Array(count: 4, repeatedValue: CGPointZero)
    var lastPosition = CGPointZero
    var orientation = Orientation.None
    var direction = Direction.None
    
    func calculateDirectionsConstrains(tile: Tile) {
        
        for var i = 0; i < directionsConstrains.count; ++i {
            directionsConstrains[i] = tile.position
        }
        
        // right check
        for var i = tile.column + 1; i < Constants.boardPositions[tile.row].count; ++i {
            if currentLevel.mainTiles[tile.row][i] != TileType.Empty { break }
            directionsConstrains[Direction.Right.rawValue] = Constants.boardPositions[tile.row][i]
        }
        
        // up check
        for var i = tile.row - 1; i >= 0; --i {
            if currentLevel.mainTiles[i][tile.column] != TileType.Empty { break }
            directionsConstrains[Direction.Up.rawValue] = Constants.boardPositions[i][tile.column]
        }
        
        // left check
        for var i = tile.column - 1; i >= 0; --i {
            if currentLevel.mainTiles[tile.row][i] != TileType.Empty { break }
            directionsConstrains[Direction.Left.rawValue] = Constants.boardPositions[tile.row][i]
        }
        
        // down check
        for var i = tile.row + 1; i < Constants.boardPositions.count; ++i {
            if currentLevel.mainTiles[i][tile.column] != TileType.Empty { break }
            directionsConstrains[Direction.Down.rawValue] = Constants.boardPositions[i][tile.column]
        }
    }
    
    func tileDragBegan(tile: Tile, touch: UITouch) {
        startedPosition = tile.position
        lastPosition = tile.position
        calculateDirectionsConstrains(tile)
    }
    
    func tileDragMoved(tile: Tile, touch: UITouch) {
        
        var currentPosition = touch.locationInNode(self)
        var delta = CGPointMake(currentPosition.x - lastPosition.x, currentPosition.y - lastPosition.y)
        
        if orientation == Orientation.None {
            if fabs(delta.x) > fabs(delta.y) {
                orientation = Orientation.Horizontal
                
                if delta.x > 0.0 {
                    direction = Direction.Right
                } else {
                    direction = Direction.Left
                }
                tile.position.x = currentPosition.x
            } else {
                orientation = Orientation.Vertical
                
                if delta.y > 0.0 {
                    direction = Direction.Down
                } else {
                    direction = Direction.Up
                }
                tile.position.y = currentPosition.y
            }
        }
        
        lastPosition = currentPosition
    }
    
    func tileDragCancelled(tile: Tile, touch: UITouch) {
        
    }
    
    func tileDragEnded(tile: Tile, touch: UITouch) {
        var currentPosition = touch.locationInNode(self)
        var delta = CGPointMake(currentPosition.x - lastPosition.x, currentPosition.y - lastPosition.y)
        println(delta)
    }
}
