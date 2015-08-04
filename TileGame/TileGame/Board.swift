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

    static let boardHorizontalMargin = (Constants.screenSize.width - 6 * Tile.tileLength - 5 * Tile.tileSpacing) / 2
    static let boardVerticalMargin = (Constants.screenSize.height - Constants.screenSize.width) / 2 +
        boardHorizontalMargin + Tile.tileLength / 2

    static let boardPositions = { () -> [[CGPoint]] in

        var board = Array(count: boardSize,
            repeatedValue: Array(count: boardSize,
                repeatedValue: CGPoint.zeroPoint))

        for var i = 0; i < boardSize; ++i {
            for var j = 0; j < boardSize; ++j {
                board[i][j] = CGPoint(
                    x: boardHorizontalMargin + Tile.tileLength / 2 + CGFloat(j) * (Tile.tileSpacing + Tile.tileLength),
                    y: boardVerticalMargin + CGFloat(boardSize - 1 - i) * (Tile.tileSpacing + Tile.tileLength))
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
        debugPrint("board deinit")
    }

    // MARK: Methods



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
//                (scene as! GameScene).header.addStar(childTile, forColor: tile.type)
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

    func getOrientationFrom(delta: CGPoint) -> Orientation {

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

    func getPlaceFromPosition(place: (row: Int, column: Int)) -> CGPoint {
        return Board.boardPositions[place.row][place.column]
    }

    func tileDragMoved(tile: Tile, at position: CGPoint) {

        currentPosition = position
        let delta = currentPosition - lastPosition
        let deltaFromStart = currentPosition - startPosition

        if currentOrientation == Orientation.None {
            currentOrientation = getOrientationFrom(deltaFromStart)
        } else {

            if currentOrientation == Orientation.Horizontal {

                if delta.x > 0 {
                    currentDirection = Direction.Right
                } else {
                    currentDirection = Direction.Left
                }

                let minColumn = limits[Direction.Left.rawValue].column
                let maxColumn = limits[Direction.Right.rawValue].column
                let minX = getPlaceFromPosition((tile.place.row, minColumn)).x
                let maxX = getPlaceFromPosition((tile.place.row, maxColumn)).x

                tile.position.x = clamp(minX, maxLimit: maxX, value: currentPosition.x)

            } else if currentOrientation == Orientation.Vertical {

                if delta.y > 0 {
                    currentDirection = Direction.Up
                } else {
                    currentDirection = Direction.Down
                }

                let minRow = limits[Direction.Down.rawValue].row
                let maxRow = limits[Direction.Up.rawValue].row
                let minY = getPlaceFromPosition((minRow, tile.place.column)).y
                let maxY = getPlaceFromPosition((maxRow, tile.place.column)).y

                tile.position.y = clamp(minY, maxLimit: maxY, value: currentPosition.y)
            }

            let startTilePosition = getPlaceFromPosition(tile.place)

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
            _ = endPosition - startPosition

            let limitPoint = getPlaceFromPosition(limits[currentDirection.rawValue])
            let middle = (limitPoint + startPosition) / 2

            var moveAction: SKAction!

            let duration = 0.1

            switch currentOrientation {
            case Orientation.Horizontal:
                if endPosition.x > middle.x {
                    let position = getPlaceFromPosition(limits[Direction.Right.rawValue])
                    moveAction = SKAction.moveToX(position.x, duration: duration)
                    moveTile(tile, to: limits[Direction.Right.rawValue])
                } else {
                    let position = getPlaceFromPosition(limits[Direction.Left.rawValue])
                    moveAction = SKAction.moveToX(position.x, duration: duration)
                    moveTile(tile, to: limits[Direction.Left.rawValue])
                }
            case Orientation.Vertical:
                if endPosition.y > middle.y {
                    let position = getPlaceFromPosition(limits[Direction.Up.rawValue])
                    moveAction = SKAction.moveToY(position.y, duration: duration)
                    moveTile(tile, to: limits[Direction.Up.rawValue])
                } else {
                    let position = getPlaceFromPosition(limits[Direction.Down.rawValue])
                    moveAction = SKAction.moveToY(position.y, duration: duration)
                    moveTile(tile, to: limits[Direction.Down.rawValue])
                }
            default:
                moveAction = nil
            }

            tile.runAction(moveAction) { [unowned self] in
                var tilesToDestroy = self.getNeighbours(tile)
                if tilesToDestroy.count >= 3 {

//                    (self.scene as! GameScene).header.addColor(tilesToDestroy.count, forColor: tile.type)
                    for tile in tilesToDestroy {
                        self.destroyTile(tile)
                    }
                }

                
            }
        }

        currentOrientation = Orientation.None
        currentDirection = Direction.None
    }

}