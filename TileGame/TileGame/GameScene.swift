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

    // STATIC TEXTURES
    private static var texturesAreCreated = false
    static var tileTexture: SKTexture! = SKTexture()
    static var starTexture: SKTexture! = SKTexture()
    static var tile2RoundCornersTexture: SKTexture = SKTexture()
    static var headerTexture: SKTexture = SKTexture()

    var controller: GameViewController!

    var levelType: LevelType!
    var levelTypeCounter: Int!

    var levelsInfo = LevelsInfo.sharedInstance
    var level: (section: Int, number: Int)!

    var header: Header!
    var menu: Menu!
    var board: Board!
    var overlay: SKSpriteNode!

    var gameState: GameState!

    var counter: Counter!
    var moves: Int!
    var currentMoves: Int!


    // MARK: SKScene

    deinit {
        println("gs deinit")
    }

    override func didMoveToView(view: SKView) {
        super.didMoveToView(view)
        /* Setup your scene here */

        // Create textures one time only
        if !GameScene.texturesAreCreated {
            GameScene.createTextures(view)
            GameScene.texturesAreCreated = true
        }

        board = Board()
        board.zPosition = -2

        overlay = SKSpriteNode(color: SKColor.blackColor(), size: size);
        overlay.anchorPoint = CGPointZero
        overlay.zPosition = -1
        overlay.name = "overlay"
        overlay.alpha = 0

        header = Header()
        header.zPosition = 1

        menu = Menu(view: view)
        menu.zPosition = 0
        menu.alpha = 0

        populateScene()

        backgroundColor = UIColor(red: 255 / 255, green: 237 / 255, blue: 218 / 255, alpha: 0.25)

        addChild(board)
        addChild(header)
    }

    // MARK: Touches

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)

        let location = (touches.first as! UITouch).locationInNode(self)
        let node = nodeAtPoint(location)

        if node.name == "overlay" {
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

    func gameOver() {

    }

    func showAd() {
        
    }

    func nextLevel() {

    }

    func restartLevel() {

    }

    func share() {

    }

    func goToLobby() {
        controller!.dismissViewControllerAnimated(true, completion: nil)
    }

    func toogleMenu() {

        if gameState != GameState.Pause {

            if overlay.parent == nil && menu.parent == nil {
                gameState = GameState.Pause

                addChild(overlay)
                addChild(menu)
                overlay.runAction(SKAction.fadeAlphaTo(0.75, duration: 0.3))
                menu.runAction(SKAction.fadeInWithDuration(0.3))
            }
        } else {
            gameState = GameState.Play

            menu.runAction(SKAction.fadeOutWithDuration(0.3), completion: {
                self.menu.removeFromParent()
            })

            overlay.runAction(SKAction.fadeOutWithDuration(0.3), completion: {
                self.overlay.removeFromParent()
            })
        }
    }

    private static func createTextures(view: SKView) {

        let screenRatio = Constants.screenRatio

        let starPath = getStarPath(0, 0, Tile.tileLength / 4 * screenRatio, 5, 2)
        let roundRectPath = UIBezierPath(
            roundedRect: CGRectMake(0, 0, Tile.tileLength * screenRatio , Tile.tileLength * screenRatio),
            cornerRadius: Board.tileCornerRadius * screenRatio).CGPath

        let tile2RoundCornersPath = UIBezierPath(
            roundedRect: CGRectMake(0, 0, Tile.tileLength * screenRatio, Tile.tileLength * screenRatio),
            byRoundingCorners: UIRectCorner.TopLeft | UIRectCorner.BottomRight,
            cornerRadii: CGSizeMake(Tile.tileLength * screenRatio / 2, Tile.tileLength * screenRatio / 2))

        let tile2RoundCornersShape = SKShapeNode()
        tile2RoundCornersShape.path = tile2RoundCornersPath.CGPath
        tile2RoundCornersShape.fillColor = SKColor.whiteColor()
        tile2RoundCornersTexture = view.textureFromNode(tile2RoundCornersShape)

        let headerBackgroundPath = UIBezierPath(
            roundedRect: CGRectMake(0, 0, Constants.screenSize.width * screenRatio, Tile.tileLength * screenRatio),
            byRoundingCorners: UIRectCorner.TopLeft | UIRectCorner.TopRight,
            cornerRadii: CGSizeMake(Tile.tileLength * screenRatio / 2, Tile.tileLength * screenRatio / 2))

        let headerBackgroundShape = SKShapeNode()
        headerBackgroundShape.path = headerBackgroundPath.CGPath
        headerBackgroundShape.fillColor = SKColor.whiteColor()
        headerTexture = view.textureFromNode(headerBackgroundShape)

        let tileShape = SKShapeNode()
        tileShape.fillColor = UIColor.whiteColor()
        tileShape.path = roundRectPath
        tileTexture = view.textureFromNode(tileShape)

        let starShape = SKShapeNode()
        starShape.fillColor = SKColor.whiteColor()
        starShape.path = starPath
        starTexture = view.textureFromNode(starShape)

        starShape.fillColor = SKColor.blackColor()
        starShape.setScale(0.75)
        starShape.zRotation = -15 * CGFloat(M_PI) / 180
        starShape.position = CGPointMake(tileShape.frame.width / 2, tileShape.frame.height / 2)
        tileShape.addChild(starShape)
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
