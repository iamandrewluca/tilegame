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

    var controller: GameViewController!

    var levelType: LevelType! = LevelType.None
    var levelTypeCounter: Int = 0

    var levelsInfo = LevelsInfo.sharedInstance
    var level = (section: 0, number: 0)

    var header: Header!
    var menu: Menu!
    var board: Board!
    var overlay: SKSpriteNode!

    var gameState: GameState = GameState.Stop

    // MARK: SKScene

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        /* Setup your scene here */

        // this must moved to view contorller
        Constants.sceneView = view

        board = Board()
        board.zPosition = -2

        overlay = SKSpriteNode(color: SKColor.blackColor(), size: size);
        overlay.anchorPoint = CGPointZero
        overlay.zPosition = -1
        overlay.name = "overlay"
        overlay.alpha = 0

        header = Header()
        header.zPosition = 1

        menu = Menu()
        menu.zPosition = 0
        menu.alpha = 0

        populateScene()

        addChild(board)
        addChild(header)
    }

    // MARK: Touches

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)

        var overlay = nodeAtPoint((touches.first as! UITouch).locationInNode(self))

        if overlay.name == "overlay" {
            toogleMenu()
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
    }

    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
    }

    // MARK: Drag
    
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
    
    // MARK: Methods

    func goToLobby() {
        controller!.dismissViewControllerAnimated(true, completion: nil)
    }

    func toogleMenu() {

        if gameState != GameState.Pause {

            if overlay.parent == nil && menu.parent == nil {
                gameState = GameState.Pause

                addChild(overlay)
                overlay.runAction(SKAction.fadeAlphaTo(0.75, duration: 0.2))
                addChild(menu)
                menu.runAction(SKAction.fadeAlphaTo(0.75, duration: 0.2))
            }
        } else {
            gameState = GameState.Play

            overlay.runAction(SKAction.fadeOutWithDuration(0.2), completion: {
                self.overlay.removeFromParent()
            })
            menu.runAction(SKAction.fadeOutWithDuration(0.2), completion: {
                self.menu.removeFromParent()
            })
        }
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
                for var i = 0; i < targets.count; ++i {
                    header.setColorTarget(targets[i], forColor: TileType(rawValue: i + 1)!)
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
        case Play, Pause, Stop, Win, Lost
    }

    enum LevelType: Int {
        case None = -1, FreeTime, LimitedTime, LimitedMoves
    }
}
