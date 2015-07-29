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
    var leftTopLabel = SKLabelNode()
    var leftBottomLabel = SKLabelNode()

    // MARK: SKNode
    
    override init() {
        super.init()

        userInteractionEnabled = true
        
        self.position = CGPointMake(0, Constants.screenSize.height - Tile.tileLength)
        
        // add header background
        let headerBackground = SKSpriteNode(
            texture: GameScene.headerBackgroundTexture,
            color: Constants.navigationBackgroundColor,
            size: CGSizeMake(Constants.screenSize.width, Tile.tileLength))
        
        headerBackground.colorBlendFactor = 1.0
        headerBackground.anchorPoint = CGPointZero
        addChild(headerBackground)
        
        // add left icon
        let leftIcon = SKSpriteNode(
            texture: GameScene.headerLeftCornerTexture,
            color: Constants.navigationButtonColor,
            size: Tile.tileSize)

        leftIcon.position = CGPoint(x: Tile.tileLength / 2, y: Tile.tileLength / 2)
        leftIcon.colorBlendFactor = 1.0
        addChild(leftIcon)
        
        // add labels to left icon

        let tileTwoThirds = Tile.tileLength / 3 * 2

        leftBottomLabel.fontColor = Constants.textColor
        leftBottomLabel.fontName = Constants.secondaryFont
        leftBottomLabel.text = "SECONDS"
        leftBottomLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Top
        leftBottomLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        leftBottomLabel.fontSize *= tileTwoThirds / leftBottomLabel.frame.width

        leftTopLabel.fontColor = Constants.textColor
        leftTopLabel.fontName = Constants.primaryFont
        leftTopLabel.text = "999"
        leftTopLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Baseline
        leftTopLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center

        let heightWithoutBottom = tileTwoThirds - leftBottomLabel.frame.height
        let aspectRatio = min(tileTwoThirds / leftTopLabel.frame.width , heightWithoutBottom / leftTopLabel.frame.height)

        leftTopLabel.fontSize *= aspectRatio

        let downMove = Tile.tileLength / 2 - leftBottomLabel.frame.height - Tile.tileLength / 3 / 2

        leftTopLabel.position.y -= downMove
        leftBottomLabel.position.y -= downMove

        leftIcon.addChild(leftTopLabel)
        leftIcon.addChild(leftBottomLabel)
        
        // add right icon
        let rightIcon = SKSpriteNode(
            texture: GameScene.headerRightCornerTexture,
            color: Constants.navigationButtonColor,
            size: Tile.tileSize)

        rightIcon.colorBlendFactor = 1.0

        var pause = SKSpriteNode(texture: SKTexture(imageNamed: "Pause"), color: Constants.textColor, size: Tile.tileSize / 2)
        pause.colorBlendFactor = 1.0
        pause.name = "pause"

        rightIcon.addChild(pause)
        rightIcon.position = CGPointMake(Constants.screenSize.width - Tile.tileLength / 2, Tile.tileLength / 2)
        rightIcon.name = "pause"
        addChild(rightIcon)
        
        for var i = 0; i < Header.headerPositions.count; ++i {

            // add top tiles
            var tile = SKSpriteNode(
                texture: GameScene.tileTexture,
                color: TileType(rawValue: i + 1)?.tileColor,
                size: CGSizeMake(Tile.tileLength / 2, Tile.tileLength / 2))

            var star = SKSpriteNode(
                texture: GameScene.starTexture,
                color: Constants.navigationBackgroundColor,
                size: CGSizeMake(Tile.tileLength / 3, Tile.tileLength / 3))
            star.colorBlendFactor = 1.0
            star.zRotation = degree2radian(-15)
            tile.addChild(star)

            tile.colorBlendFactor = 1.0
            tile.position = Header.headerPositions[i]
            tile.position.y += Tile.tileLength / 8
            addChild(tile)
            
            // add labels
            colorLabels[i] = SKLabelNode()
            colorLabels[i]!.fontColor = Constants.textColor
            colorLabels[i]!.fontName = Constants.secondaryFont
            colorLabels[i]!.text = "99/99"
            colorLabels[i]!.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
            colorLabels[i]!.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center


            colorLabels[i]!.fontSize *= Tile.tileLength / 8 * 1.5 / colorLabels[i]!.frame.height

            colorLabels[i]!.position = Header.headerPositions[i]
            colorLabels[i]!.position.y -= Tile.tileLength / 8 * 2.5
            addChild(colorLabels[i]!)
            

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

    // MARK: Methods

    func addStar(tile: Tile, forColor: TileType) {

        let scenePosition = scene!.convertPoint(tile.position, fromNode: (scene as! GameScene).board)
        let headerPosition = scene!.convertPoint(scenePosition, toNode: (scene as! GameScene).header)

        tile.position = headerPosition

        tile.removeFromParent()
        addChild(tile)

        var finalPosition = Header.headerPositions[forColor.rawValue - 1]
        finalPosition.y += Tile.tileLength / 8

        let moveAction = SKAction.group([
            SKAction.moveTo(finalPosition, duration: 0.2),
            SKAction.scaleTo(2/6, duration: 0.2),
            SKAction.rotateByAngle(degree2radian(-15), duration: 0.2)])

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
}