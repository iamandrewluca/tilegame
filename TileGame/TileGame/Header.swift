//
//  Header.swift
//  TileGame
//
//  Created by Andrei Luca on 4/27/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Header: SKNode {

    // MARK: Members

    static var headerPositions = { () -> [CGPoint] in

        var points = Array(count: 5, repeatedValue: CGPoint.zeroPoint)

        let smallTileWidth = Tile.tileLength / 2
        let widthWithoutLR = Constants.screenSize.width - Tile.tileLength * 2
        let yMiddle = Tile.tileLength / 2
        let space = (widthWithoutLR - 5 * smallTileWidth) / 6
        let startX = Tile.tileLength + space + smallTileWidth / 2

        for var i = 0; i < 5; ++i {
            let x = startX + CGFloat(i) * (space + smallTileWidth)
            points[i] = CGPointMake(x, yMiddle)
        }

        return points
    }()

    var colorTargets = Array(count: 5, repeatedValue: 0)
    var currentTargets = Array(count: 5, repeatedValue: 0)
    var colorStars = Array(count: 5, repeatedValue: false)

    var colorLabels = Array(count: 5, repeatedValue: SKLabelNode?.None)
    var levelTopLabel = SKLabelNode()
    var levelBottomLabel = SKLabelNode()

    // MARK: Methods

    func addStar(tile: Tile, forColor: TileType) {

        let scenePosition = scene!.convertPoint(tile.position, fromNode: (scene as! GameScene).board)
        let headerPosition = scene!.convertPoint(scenePosition, toNode: (scene as! GameScene).header)

        tile.position = headerPosition

        tile.removeFromParent()
        addChild(tile)

        let moveAction = SKAction.group([
            SKAction.moveTo(Header.headerPositions[forColor.rawValue - 1], duration: 0.2),
            SKAction.scaleTo(0.30, duration: 0.2),
            SKAction.rotateByAngle(-15 * CGFloat(M_PI) / 180, duration: 0.2)])

        moveAction.timingMode = SKActionTimingMode.EaseInEaseOut

        tile.runAction(moveAction)
    }

    func addColor(value: Int, forColor: TileType) {

        let pos = forColor.rawValue - 1

        currentTargets[pos] += value
        colorLabels[pos]!.text = String("\(currentTargets[pos])/\(colorTargets[pos])")
    }

    func setColorTarget(value: Int, forColor: TileType) {
        colorTargets[forColor.rawValue - 1] = value
    }

    // MARK: SKNode
    
    override init() {
        super.init()
        
        self.position = CGPointMake(0, Constants.screenSize.height - Tile.tileLength)
        userInteractionEnabled = true
        
        // add header background
        let headerBackground = SKSpriteNode(
            texture: GameScene.headerTexture,
            color: SKColor.grayColor(),
            size: CGSizeMake(Constants.screenSize.width, Tile.tileLength))
        
        headerBackground.colorBlendFactor = 1.0
        headerBackground.anchorPoint = CGPointZero
        addChild(headerBackground)
        
        // add left icon
        let leftIcon = SKSpriteNode(
            texture: GameScene.tile2RoundCornersTexture,
            color: SKColor.whiteColor(),
            size: Tile.tileSize)
        
        leftIcon.anchorPoint = CGPointZero
        addChild(leftIcon)
        
        // add labels to left icon
        let pos = CGPointMake(Tile.tileLength / 2, Tile.tileLength / 2)
        
        levelTopLabel.position = pos
        levelTopLabel.position.y += 5
        levelTopLabel.fontColor = SKColor.blackColor()
        levelTopLabel.fontSize = 16
        levelTopLabel.text = "10"
        levelTopLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelTopLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center

        levelBottomLabel.position = pos
        levelBottomLabel.position.y -= 8
        levelBottomLabel.fontColor = SKColor.blackColor()
        levelBottomLabel.fontSize = 8
        levelBottomLabel.text = "LEVEL"
        levelBottomLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        levelBottomLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        
        leftIcon.addChild(levelTopLabel)
        leftIcon.addChild(levelBottomLabel)
        
        // add right icon
        let rightIcon = SKSpriteNode(
            texture: GameScene.tile2RoundCornersTexture,
            color: SKColor.whiteColor(),
            size: Tile.tileSize)

        var pause = SKSpriteNode(imageNamed: "Pause")
        pause.zRotation = degree2radian(90)
        pause.anchorPoint = CGPoint.zeroPoint
        
        rightIcon.addChild(pause)
        rightIcon.anchorPoint = CGPointMake(1.0, 0)
        rightIcon.position = CGPointMake(Constants.screenSize.width, Tile.tileLength)
        rightIcon.zRotation = degree2radian(90)
        rightIcon.name = "pause"
        addChild(rightIcon)
        
        for var i = 0; i < Header.headerPositions.count; ++i {
            
            // add labels
            colorLabels[i] = SKLabelNode()
            colorLabels[i]!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            colorLabels[i]!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
            colorLabels[i]!.text = "0/0"
            colorLabels[i]!.fontSize = 10
            colorLabels[i]!.position = Header.headerPositions[i]
            colorLabels[i]!.position.y -= Tile.tileLength / 3
            addChild(colorLabels[i]!)
            
            // add tileStars
            var tileStar = SKSpriteNode(
                texture: GameScene.starTexture,
                color: TileType(rawValue: i + 1)?.tileColor,
                size: CGSizeMake(Tile.tileLength / 2, Tile.tileLength / 2))
            
            tileStar.colorBlendFactor = 1.0
            tileStar.position = Header.headerPositions[i]
            tileStar.position.y += Tile.tileLength / 8
            addChild(tileStar)
        }
    }


    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    deinit {
        println("heaer deinit")
    }

    // MARK: Touches

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        let touch = touches.first as! UITouch
        let point = touch.locationInNode(self)
        let node = self.nodeAtPoint(point)

        if node.name == "pause" {
            (scene as! GameScene).toogleMenu()
        }
    }

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
    }
    
    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
    }
    
    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
    }
}