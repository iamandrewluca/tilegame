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
    
    var startPosition = CGPointZero
    var currentPosition = CGPointZero
    var lastPosition = CGPointZero
    var endPosition = CGPointZero
    
    var limits = Array(count: 4, repeatedValue: CGPointZero)
    var currentOrientation = Orientation.None
    var currentDirection = Direction.None
    
    func calculateLimits(tile: Tile) {
        
        for var i = 0; i < limits.count; ++i {
            limits[i] = tile.position
        }
        
        // right check
        for var i = tile.column + 1; i < Constants.boardPositions[tile.row].count; ++i {
            if currentLevel.mainTiles[tile.row][i] != TileType.Empty { break }
            limits[Direction.Right.rawValue] = Constants.boardPositions[tile.row][i]
        }
        
        // up check
        for var i = tile.row - 1; i >= 0; --i {
            if currentLevel.mainTiles[i][tile.column] != TileType.Empty { break }
            limits[Direction.Up.rawValue] = Constants.boardPositions[i][tile.column]
        }
        
        // left check
        for var i = tile.column - 1; i >= 0; --i {
            if currentLevel.mainTiles[tile.row][i] != TileType.Empty { break }
            limits[Direction.Left.rawValue] = Constants.boardPositions[tile.row][i]
        }
        
        // down check
        for var i = tile.row + 1; i < Constants.boardPositions.count; ++i {
            if currentLevel.mainTiles[i][tile.column] != TileType.Empty { break }
            limits[Direction.Down.rawValue] = Constants.boardPositions[i][tile.column]
        }
    }
    
    func tileDragBegan(tile: Tile, touch: UITouch) {
        
        println("began")
        
        calculateLimits(tile)
        
        startPosition = tile.position
        currentPosition = tile.position
        lastPosition = tile.position
        endPosition = tile.position
        
        currentOrientation = Orientation.None
        currentDirection = Direction.None
    }
    
    func tileDragMoved(tile: Tile, touch: UITouch) {
        
        currentPosition = touch.locationInNode(self)
        var delta = currentPosition - lastPosition
        lastPosition = currentPosition
        
        if currentOrientation == Orientation.None {
            var deltaFromStart = currentPosition - startPosition
            
            if max(fabs(deltaFromStart.x), fabs(deltaFromStart.y)) > 10 {
                if fabs(deltaFromStart.x) > fabs(deltaFromStart.y) {
                    currentOrientation = Orientation.Horizontal
                    
                    if deltaFromStart.x > 0.0 {
                        currentDirection = Direction.Right
                    } else {
                        currentDirection = Direction.Left
                    }
                } else {
                    currentOrientation = Orientation.Vertical
                    
                    if deltaFromStart.y > 0.0 {
                        currentDirection = Direction.Down
                    } else {
                        currentDirection = Direction.Up
                    }
                }
            }
        } else if currentOrientation == Orientation.Horizontal {
            tile.position.x = clamp(limits[Direction.Left.rawValue].x,
                limits[Direction.Right.rawValue].x, currentPosition.x)
        } else if currentOrientation == Orientation.Vertical {
            tile.position.y = clamp(limits[Direction.Up.rawValue].y,
                limits[Direction.Down.rawValue].y, currentPosition.y)
        }
    }
    
    func tileDragCancelled(tile: Tile, touch: UITouch) {
        
        println("cancel")
        
        tileDragEnded(tile, touch: touch)
    }
    
    func tileDragEnded(tile: Tile, touch: UITouch) {
        
        println("end")
        
        endPosition = touch.locationInNode(self)
        var delta = endPosition - startPosition
        lastPosition = endPosition
        
        var middle = (limits[currentDirection.rawValue] + startPosition) / 2
        
        var moveAction: SKAction!
        
        switch currentOrientation {
        case Orientation.Horizontal:
            if endPosition.x > middle.x {
                moveAction = SKAction.moveToX(limits[Direction.Right.rawValue].x, duration: 0.2)
            } else {
                moveAction = SKAction.moveToX(limits[Direction.Left.rawValue].x, duration: 0.2)
            }
        case Orientation.Vertical:
            if endPosition.y > middle.y {
                moveAction = SKAction.moveToY(limits[Direction.Down.rawValue].y, duration: 0.2)
            } else {
                moveAction = SKAction.moveToY(limits[Direction.Up.rawValue].y, duration: 0.2)
            }
        default:
            moveAction = nil
        }
        
        tile.runAction(moveAction)
    }
}
