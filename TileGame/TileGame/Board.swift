//
//  Board.swift
//  TileGame
//
//  Created by Andrei Luca on 6/24/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Board: SKNode {

    // MARK: Members

    var tiles = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: Tile?.None))
    var back = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: SKSpriteNode?.None))

    // MARK: Methods

    func addBackTile(row: Int, column: Int) {

        var backTile = SKSpriteNode(texture: Constants.tileTexture,
            color: UIColor.whiteColor(), size: Constants.tileSize)

        backTile.position = Constants.boardPositions[row][column]

        back[row][column] = backTile

        addChild(backTile)
    }

    func addTile(row: Int, column: Int, type: TileType, childType: TileType) {

        var tile = Tile(tileRow: row, tileColumn: column, tileType: type)

        if childType != TileType.Empty {
            tile.childTile = Tile(tileRow: row, tileColumn: column, tileType: childType)
        }

        tiles[row][column] = tile
        tile.zPosition = 1

        addChild(tile)
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

    var startPosition = CGPointZero
    var currentPosition = CGPointZero
    var lastPosition = CGPointZero
    var endPosition = CGPointZero

    var limits = Array(count: 4, repeatedValue: (row: Int(), column: Int()))
    var currentOrientation = Orientation.None
    var startDirection = Direction.None
    var currentDirection = Direction.None

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

    func tileDragBegan(tile: Tile, at position: CGPoint) {

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

        if max(fabs(delta.x), fabs(delta.y)) > 5 {
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

    func tileDragMoved(tile: Tile, at position: CGPoint) {

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

    func tileDragCancelled(tile: Tile, at position: CGPoint) {
        tileDragEnded(tile, touch: touch)
    }

    func tileDragEnded(tile: Tile, at position: CGPoint) {

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

}