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

    // MARK: Members

    var levelType: LevelType! = LevelType.None
    var levelTypeCounter: Int = 0

    var colorTargets = Array(count: 5, repeatedValue: 0)
    var currentTargets = Array(count: 5, repeatedValue: 0)
    var colorStars = Array(count: 5, repeatedValue: false)

    var levelsInfo = LevelsInfo.sharedInstance
    var level = (section: 0, number: 0)

    var header: Header!
    var menu: Menu!
    var board: Board!

    var gameState: GameState = GameState.Hold

    // MARK: SKScene

    override func didMoveToView(view: SKView) {
        /* Setup your scene here */

        // move to view contorller
        Constants.sceneView = view

        header = Header()
        board = Board()
        menu = Menu()

        populateScene()

        addChild(header)
        addChild(board)
    }

    // MARK: Methods
    
    func tileDragBegan(tile: Tile, touch: UITouch) {
        board.tileDragBegan(tile, at: touch.locationInNode(self))
    }
    
    func tileDragMoved(tile: Tile, touch: UITouch) {
        board.tileDragMoved(tile, at: touch.locationInNode(self))
    }
    
    func tileDragCancelled(tile: Tile, touch: UITouch) {        
        board.tileDragCancelled(tile, at: touch.locationInNode(self))
    }
    
    func tileDragEnded(tile: Tile, touch: UITouch) {
        board.tileDragEnded(tile, at: touch.locationInNode(self))
    }
    
    

    func populateScene() {

        if let level = loadJSONFromBundle("section_\(level.section)_level_\(level.number)") {

            // get level type
            if let type = level["levelType"] as? Int, counter = level["levelTypeCounter"] as? Int {
                levelType = LevelType(rawValue: type)
                levelTypeCounter = counter

            }

            // get tiles targets
            if let targets = level["colorTargets"] as? Array<Int> {
                for var i = 0; i < colorTargets.count; ++i {
                    colorTargets[i] = targets[i]
                    header.colorLabels[i]?.text = String("0/\(colorTargets[i])")
                }
            }

            // get main and child tile types
            if let tiles = level["tiles"] as? Array<Array<Int>> {
                for var i = 0; i < tiles.count; ++i {
                    for var j = 0; j < tiles[i].count; ++j {

                        // if is not hole
                        if tiles[i][j] != -1 {

                            // create back tile
                            board.addBackTile(i, column: j)

                            // create main and child tile
                            if tiles[i][j] != 0 {
                                var mainTile = TileType(rawValue: tiles[i][j] / 10)
                                var childTile = TileType(rawValue: tiles[i][j] % 10)

                                board.addTile(i, column: j, type: mainTile!, childType: childTile!)
                            }
                        } else {
                            // create hole tile
                            board.addTile(i, column: j, type: TileType.Unknown, childType: TileType.Empty)
                        }
                    }
                }
            }
        }
    }

    func loadJSONFromBundle(filename: String) -> Dictionary<String, AnyObject>? {
        if let path = NSBundle.mainBundle().pathForResource(filename, ofType: "json") {
            var error: NSError?
            let data: NSData? = NSData(contentsOfFile: path, options: NSDataReadingOptions(), error: &error)
            if let data = data {
                let dictionary: AnyObject? = NSJSONSerialization.JSONObjectWithData(data, options: NSJSONReadingOptions(), error: &error)
                if let dictionary = dictionary as? Dictionary<String, AnyObject> {
                    return dictionary
                } else {
                    println("Level file '\(filename)' is not valid JSON: \(error!)")
                    return nil
                }
            } else {
                println("Could not load level file: \(filename), error: \(error!)")
                return nil
            }
        } else {
            println("Could not find level file: \(filename)")
            return nil
        }
    }

    enum GameState {
        case Play, Pause, Stop, Hold
    }

    enum LevelType: Int {
        case None = -1, FreeTime, LimitedTime, LimitedMoves
    }
}
