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
    
    var header = Header()
    var canSwipe = true
    var boardBackground: SKSpriteNode!
    var tileNodes = SKNode()
    var tilesBoard: [[Tile?]] = Array(count: Constants.boardSize,
        repeatedValue: Array(count: Constants.boardSize,
            repeatedValue: Tile?.None))
    
    var currentLevel: Level!
    
    // will be used when switching from one level to another
    var newLevel: Level!
    
    override func didMoveToView(view: SKView) {
        /* Setup your scene here */
        
        Constants.sceneView = view
        
        prepareBoard()
        prepareUI()
        showGame()
    }
    
    func prepareBoard() {
        
        let backgroundNodes = SKNode()
        let background = SKSpriteNode(color: SKColor.clearColor(), size: Constants.sceneSize)
        background.anchorPoint = CGPointZero
        backgroundNodes.addChild(background)

        for var i = 0; i < Constants.boardSize; ++i {
            for var j = 0; j < Constants.boardSize; ++j {
                
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
        boardBackground.anchorPoint = CGPointZero
        addChild(backgroundNodes)
    }
    
    func prepareUI() {
        header.position = CGPointMake(0, Constants.sceneSize.height - 85)
        self.addChild(header)
    }
    
    func showGame() {
//        addChild(boardBackground)
        addChild(tileNodes)
    }
    
    var startPosition = CGPointZero
    var currentPosition = CGPointZero
    var lastPosition = CGPointZero
    var endPosition = CGPointZero
    
    var limits = Array(count: 4, repeatedValue: (row: Int(), column: Int()))
    var currentOrientation = Orientation.None
    var startDirection = Direction.None
    var currentDirection = Direction.None
    
    func getRowColumnPosition(position: (row: Int, column: Int)) -> CGPoint {
        return Constants.boardPositions[position.row][position.column]
    }
    
    func moveTile(tile: Tile, to: (row: Int, column: Int)) {
        var aux = currentLevel.mainTiles[tile.row][tile.column]
        currentLevel.mainTiles[tile.row][tile.column] = currentLevel.mainTiles[to.row][to.column]
        currentLevel.mainTiles[to.row][to.column] = aux
        
        aux = currentLevel.childTiles[tile.row][tile.column]
        currentLevel.childTiles[tile.row][tile.column] = currentLevel.childTiles[to.row][to.column]
        currentLevel.childTiles[to.row][to.column] = aux
        
        tilesBoard[to.row][to.column] = tile
        tilesBoard[tile.row][tile.column] = nil
        
        tile.row = to.row
        tile.column = to.column
    }
    
    func getNeighbours(startTile: Tile) -> Array<Tile> {
        
        var neighbours = Array<Tile>()
        var lastTiles = Array<Tile>()
        
        lastTiles.append(startTile)
        
        while lastTiles.count > 0 {
            
            var nextTiles = Array<Tile>()
            
            for tile in lastTiles {
                if !tile.visited && tile.type == startTile.type {
                    tile.visited = true
                    neighbours.append(tile)
                    
                    if tile.row - 1 >= 0 {
                        if let neighbour = tilesBoard[tile.row - 1][tile.column] {
                            nextTiles.append(neighbour)
                        }
                    }
                    
                    if tile.row + 1 < Constants.boardSize {
                        if let neighbour = tilesBoard[tile.row + 1][tile.column] {
                            nextTiles.append(neighbour)
                        }
                    }
                    
                    if tile.column - 1 >= 0 {
                        if let neighbour = tilesBoard[tile.row][tile.column - 1] {
                            nextTiles.append(neighbour)
                        }
                    }
                    
                    if tile.column + 1 < Constants.boardSize {
                        if let neighbour = tilesBoard[tile.row][tile.column + 1] {
                            nextTiles.append(neighbour)
                        }
                    }
                }
            }
            
            lastTiles.removeAll(keepCapacity: true)
            lastTiles += nextTiles
            nextTiles.removeAll(keepCapacity: true)
        }
        
        for tile in neighbours {
            tile.visited = false
        }
        
        return neighbours
    }
    
    
    
    func calculateLimits(tile: Tile) {
        
        // set all limits to current position
        for var i = 0; i < limits.count; ++i {
            limits[i] = (tile.row, tile.column)
        }
        
        // right check
        for var i = tile.column + 1; i < Constants.boardSize; ++i {
            if currentLevel.mainTiles[tile.row][i] != TileType.Empty { break }
            limits[Direction.Right.rawValue] = (tile.row, i)
        }
        
        // up check
        for var i = tile.row - 1; i >= 0; --i {
            if currentLevel.mainTiles[i][tile.column] != TileType.Empty { break }
            limits[Direction.Up.rawValue] = (i, tile.column)
        }
        
        // left check
        for var i = tile.column - 1; i >= 0; --i {
            if currentLevel.mainTiles[tile.row][i] != TileType.Empty { break }
            limits[Direction.Left.rawValue] = (tile.row, i)
        }
        
        // down check
        for var i = tile.row + 1; i < Constants.boardSize; ++i {
            if currentLevel.mainTiles[i][tile.column] != TileType.Empty { break }
            limits[Direction.Down.rawValue] = (i, tile.column)
        }
    }
    
    func tileDragBegan(tile: Tile, touch: UITouch) {
        
        calculateLimits(tile)
        
        startPosition = touch.locationInNode(self)
        currentPosition = startPosition
        lastPosition = startPosition
        endPosition = startPosition
        
        currentOrientation = Orientation.None
        currentDirection = Direction.None
        startDirection = Direction.None
    }
    
    func getOrientationFrom(#delta: CGPoint) -> Orientation {
        
        var orientation = Orientation.None
        
        if max(fabs(delta.x), fabs(delta.y)) > 10 {
            if fabs(delta.x) > fabs(delta.y) {
                orientation = Orientation.Horizontal
                
                if delta.x > 0.0 {
                    startDirection = Direction.Right
                    currentDirection = startDirection
                } else {
                    startDirection = Direction.Left
                    currentDirection = startDirection
                }
            } else {
                orientation = Orientation.Vertical
                
                if delta.y > 0.0 {
                    startDirection = Direction.Up
                    currentDirection = startDirection
                } else {
                    startDirection = Direction.Down
                    currentDirection = startDirection
                }
            }
        }
        
        return orientation
    }
    
    func tileDragMoved(tile: Tile, touch: UITouch) {
        
        currentPosition = touch.locationInNode(self)
        var delta = currentPosition - lastPosition
        var deltaFromStart = currentPosition - startPosition
        
        if currentOrientation == Orientation.None {
            currentOrientation = getOrientationFrom(delta: deltaFromStart)
        } else {
            
            if currentOrientation == Orientation.Horizontal {
                
                if delta.x > 0 {
                    currentDirection = Direction.Right
                } else {
                    currentDirection = Direction.Left
                }
                
                var minColumn = limits[Direction.Left.rawValue].column
                var maxColumn = limits[Direction.Right.rawValue].column
                var minX = Constants.boardPositions[tile.row][minColumn].x
                var maxX = Constants.boardPositions[tile.row][maxColumn].x
                
                tile.position.x = clamp(minX, maxX, currentPosition.x)
                
            } else if currentOrientation == Orientation.Vertical {
                
                if delta.y > 0 {
                    currentDirection = Direction.Down
                } else {
                    currentDirection = Direction.Up
                }
                
                var minRow = limits[Direction.Down.rawValue].row
                var maxRow = limits[Direction.Up.rawValue].row
                var minY = Constants.boardPositions[minRow][tile.column].y
                var maxY = Constants.boardPositions[maxRow][tile.column].y
                
                tile.position.y = clamp(minY, maxY, currentPosition.y)
            }
            
            var startTilePosition = Constants.boardPositions[tile.row][tile.column]
            
            if startTilePosition == tile.position {
                currentOrientation = Orientation.None
            }
        }
        
        lastPosition = currentPosition
    }
    
    func tileDragCancelled(tile: Tile, touch: UITouch) {        
        tileDragEnded(tile, touch: touch)
    }
    
    func tileDragEnded(tile: Tile, touch: UITouch) {
        
        if currentOrientation != Orientation.None {
            
            endPosition = touch.locationInNode(self)
            var delta = endPosition - startPosition
            
            var limitPoint = getRowColumnPosition(limits[currentDirection.rawValue])
            var middle = (limitPoint + startPosition) / 2
            
            var moveAction: SKAction!
            
            switch currentOrientation {
            case Orientation.Horizontal:
                if endPosition.x > middle.x {
                    var position = getRowColumnPosition(limits[Direction.Right.rawValue])
                    moveAction = SKAction.moveToX(position.x, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Right.rawValue])
                } else {
                    var position = getRowColumnPosition(limits[Direction.Left.rawValue])
                    moveAction = SKAction.moveToX(position.x, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Left.rawValue])
                }
            case Orientation.Vertical:
                if endPosition.y > middle.y {
                    var position = getRowColumnPosition(limits[Direction.Up.rawValue])
                    moveAction = SKAction.moveToY(position.y, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Up.rawValue])
                } else {
                    var position = getRowColumnPosition(limits[Direction.Down.rawValue])
                    moveAction = SKAction.moveToY(position.y, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Down.rawValue])
                }
            default:
                moveAction = nil
            }
            
            tile.runAction(moveAction) {
                var tilesToDestroy = self.getNeighbours(tile)
                if tilesToDestroy.count >= 3 {
                    for tile in tilesToDestroy {
                        self.destroyTile(tile)
                    }
                }
            }
        }
    }
    
    func destroyTile(tile: Tile) {
        
        self.currentLevel.mainTiles[tile.row][tile.column] = TileType.Empty
        self.currentLevel.childTiles[tile.row][tile.column] = TileType.Empty
        tile.removeFromParent()
        
        if let childTile = tile.childTile {
            
            if childTile.type != TileType.Star {
                
                childTile.position = tile.position
                childTile.userInteractionEnabled = true
                childTile.row = tile.row
                childTile.column = tile.column
                childTile.runAction(SKAction.scaleTo(1, duration: 0))
                self.currentLevel.mainTiles[tile.row][tile.column] = childTile.type
                self.tilesBoard[tile.row][tile.column] = childTile
                childTile.removeFromParent()
                self.addChild(childTile)
                
            } else {
                
            }
        }
    }
}
