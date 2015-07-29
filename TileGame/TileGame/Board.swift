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

    static let tileCornerRadius = Tile.tileLength / 4
    static let tileSpacing = Tile.tileLength / 8

    // boardSize x boardSize
    static let boardSize = 6

    static let boardHorizontalMargin = (Constants.screenSize.width - 6 * Tile.tileLength - 5 * tileSpacing) / 2
    static let boardVerticalMargin = (Constants.screenSize.height - Constants.screenSize.width) / 2 +
        boardHorizontalMargin + Tile.tileLength / 2

    static let boardPositions = { () -> [[CGPoint]] in

        var board = Array(count: boardSize,
            repeatedValue: Array(count: boardSize,
                repeatedValue: CGPoint.zeroPoint))

        for var i = 0; i < boardSize; ++i {
            for var j = 0; j < boardSize; ++j {
                board[i][j] = CGPoint(
                    x: boardHorizontalMargin + Tile.tileLength / 2 + CGFloat(j) * (tileSpacing + Tile.tileLength),
                    y: boardVerticalMargin + CGFloat(boardSize - 1 - i) * (tileSpacing + Tile.tileLength))
            }
        }

        return board
    }()

    var tiles = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: Tile?.None))
    var back = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: SKSpriteNode?.None))

    var startPosition = CGPointZero
    var currentPosition = CGPointZero
    var lastPosition = CGPointZero
    var endPosition = CGPointZero

    var limits = Array(count: 4, repeatedValue: (row: 0, column: 0))
    var currentOrientation = Orientation.None
    var startDirection = Direction.None
    var currentDirection = Direction.None

    // MARK: SKNode

    deinit {
        println("board deinit")
    }

    // MARK: Methods

    func addBackTile(row: Int, column: Int) {

        var backTile = SKSpriteNode(texture: GameScene.tileTexture,
            color: UIColor.whiteColor(), size: Tile.tileSize)

        backTile.position = Board.boardPositions[row][column]

        back[row][column] = backTile

        backTile.zPosition = -1

        addChild(backTile)
    }

    func addTile(row: Int, column: Int, type: TileType, childType: TileType) {

        var tile = Tile(tileRow: row, tileColumn: column, tileType: type)

        if childType != TileType.Empty {
            tile.childTile = Tile(tileRow: row, tileColumn: column, tileType: childType)
        }

        tiles[row][column] = tile
        tile.zPosition = 0

        addChild(tile)
    }


    func moveTile(tile: Tile, to place: (row: Int, column: Int)) {
        tiles[place.row][place.column] = tile
        tiles[tile.place.row][tile.place.column] = Tile?.None
        tile.place = place
    }

    func destroyTile(tile: Tile) {

        tiles[tile.place.row][tile.place.column] = Tile?.None

        if let childTile = tile.childTile {

            childTile.removeFromParent()
            self.addChild(childTile)
            childTile.position = tile.position

            if childTile.type != TileType.Star {

                tiles[tile.place.row][tile.place.column] = childTile
                childTile.runAction(SKAction.sequence([SKAction.scaleTo(1.2, duration: 0.15), SKAction.scaleTo(1, duration: 0.2)]))

            } else {
                (scene as! GameScene).header.addStar(childTile, forColor: tile.type)
            }

            tile.childTile = Tile?.None
        }

        tile.runAction(SKAction.scaleTo(0, duration: 0.1)) {
            tile.removeFromParent()
        }
    }

    func getNeighbours(startTile: Tile) -> Array<Tile> {

        var neighbours = Array<Tile>()
        var lastTiles = Array<Tile>()
        var visited = Array(count: 6, repeatedValue: Array(count: 6, repeatedValue: false))

        lastTiles.append(startTile)

        while lastTiles.count > 0 {

            var nextTiles = Array<Tile>()

            for tile in lastTiles {
                if !visited[tile.place.row][tile.place.column] && tile.type == startTile.type {
                    visited[tile.place.row][tile.place.column] = true
                    neighbours.append(tile)

                    if tile.place.row - 1 >= 0 {
                        if let neighbour = tiles[tile.place.row - 1][tile.place.column] {
                            nextTiles.append(neighbour)
                        }
                    }

                    if tile.place.row + 1 < Board.boardSize {
                        if let neighbour = tiles[tile.place.row + 1][tile.place.column] {
                            nextTiles.append(neighbour)
                        }
                    }

                    if tile.place.column - 1 >= 0 {
                        if let neighbour = tiles[tile.place.row][tile.place.column - 1] {
                            nextTiles.append(neighbour)
                        }
                    }

                    if tile.place.column + 1 < Board.boardSize {
                        if let neighbour = tiles[tile.place.row][tile.place.column + 1] {
                            nextTiles.append(neighbour)
                        }
                    }
                }
            }

            lastTiles.removeAll(keepCapacity: true)
            lastTiles += nextTiles
            nextTiles.removeAll(keepCapacity: true)
        }

        return neighbours
    }

    func calculateLimits(tile: Tile) {

        // set all limits to current position
        for var i = 0; i < limits.count; ++i {
            limits[i] = tile.place
        }

        // right check
        for var i = tile.place.column + 1; i < Board.boardSize; ++i {
            if tiles[tile.place.row][i] != nil { break }
            limits[Direction.Right.rawValue] = (tile.place.row, i)
        }

        // up check
        for var i = tile.place.row - 1; i >= 0; --i {
            if tiles[i][tile.place.column] != nil { break }
            limits[Direction.Up.rawValue] = (i, tile.place.column)
        }

        // left check
        for var i = tile.place.column - 1; i >= 0; --i {
            if tiles[tile.place.row][i] != nil { break }
            limits[Direction.Left.rawValue] = (tile.place.row, i)
        }

        // down check
        for var i = tile.place.row + 1; i < Board.boardSize; ++i {
            if tiles[i][tile.place.column] != nil { break }
            limits[Direction.Down.rawValue] = (i, tile.place.column)
        }
    }

    func tileDragBegan(tile: Tile, at position: CGPoint) {

        calculateLimits(tile)

        startPosition = position
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

    func getPlacePoition(place: (row: Int, column: Int)) -> CGPoint {
        return Board.boardPositions[place.row][place.column]
    }

    func tileDragMoved(tile: Tile, at position: CGPoint) {

        currentPosition = position
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
                var minX = getPlacePoition((tile.place.row, minColumn)).x
                var maxX = getPlacePoition((tile.place.row, maxColumn)).x

                tile.position.x = clamp(minX, maxX, currentPosition.x)

            } else if currentOrientation == Orientation.Vertical {

                if delta.y > 0 {
                    currentDirection = Direction.Down
                } else {
                    currentDirection = Direction.Up
                }

                var minRow = limits[Direction.Down.rawValue].row
                var maxRow = limits[Direction.Up.rawValue].row
                var minY = getPlacePoition((minRow, tile.place.column)).y
                var maxY = getPlacePoition((maxRow, tile.place.column)).y

                tile.position.y = clamp(minY, maxY, currentPosition.y)
            }

            var startTilePosition = getPlacePoition(tile.place)

            if startTilePosition == tile.position {
                currentOrientation = Orientation.None
            }
        }

        lastPosition = currentPosition
    }

    func tileDragCancelled(tile: Tile, at position: CGPoint) {
        tileDragEnded(tile, at: position)
    }

    func tileDragEnded(tile: Tile, at position: CGPoint) {

        if currentOrientation != Orientation.None {

            endPosition = position
            var delta = endPosition - startPosition

            var limitPoint = getPlacePoition(limits[currentDirection.rawValue])
            var middle = (limitPoint + startPosition) / 2

            var moveAction: SKAction!

            switch currentOrientation {
            case Orientation.Horizontal:
                if endPosition.x > middle.x {
                    var position = getPlacePoition(limits[Direction.Right.rawValue])
                    moveAction = SKAction.moveToX(position.x, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Right.rawValue])
                } else {
                    var position = getPlacePoition(limits[Direction.Left.rawValue])
                    moveAction = SKAction.moveToX(position.x, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Left.rawValue])
                }
            case Orientation.Vertical:
                if endPosition.y > middle.y {
                    var position = getPlacePoition(limits[Direction.Up.rawValue])
                    moveAction = SKAction.moveToY(position.y, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Up.rawValue])
                } else {
                    var position = getPlacePoition(limits[Direction.Down.rawValue])
                    moveAction = SKAction.moveToY(position.y, duration: 0.2)
                    moveTile(tile, to: limits[Direction.Down.rawValue])
                }
            default:
                moveAction = nil
            }

            tile.runAction(moveAction) {
                var tilesToDestroy = self.getNeighbours(tile)
                if tilesToDestroy.count >= 3 {

                    (self.scene as! GameScene).header.addColor(tilesToDestroy.count, forColor: tile.type)
                    for tile in tilesToDestroy {
                        self.destroyTile(tile)
                    }
                }
            }
        }
    }

}