//
//  Menu.swift
//  TileGame
//
//  Created by Andrei Luca on 6/24/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Menu: SKNode {

    // MARK: Members

    static var firstBackground: SKSpriteNode!
    static var secondBackground: SKSpriteNode!
    static var middleBackground: SKSpriteNode!

    static var button1: SKSpriteNode!
    static var button2: SKSpriteNode!
    static var button3: SKSpriteNode!
    static var adButton: SKSpriteNode!

    static var topLabel: SKLabelNode!
    static var middleLabel: SKLabelNode!

    static var nodesAreCreated = false

    // MARK: SKNode

    deinit {
        println("menu deinit")
    }

    private override init() {
        super.init()
    }

    convenience init(view: SKView) {
        self.init()

        if !Menu.nodesAreCreated {
            Menu.createNodes(view)
            Menu.nodesAreCreated = true
        } else {
            Menu.firstBackground.removeFromParent()
        }

        userInteractionEnabled = true

        addChild(Menu.firstBackground)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: Methods

    static func createNodes(view: SKView) {

        let ratio = Constants.screenRatio

        // first background

        let firstBackgroundSize = CGSizeMake(
            Board.boardPositions[5][5].x - Board.boardPositions[5][0].x,
            Board.boardPositions[1][0].y - Board.boardPositions[5][0].y)

        let firstBackgroundShape = SKShapeNode()
        firstBackgroundShape.fillColor = SKColor.whiteColor()
        firstBackgroundShape.path = UIBezierPath(
            roundedRect: CGRectMake(0, 0, firstBackgroundSize.width * ratio, firstBackgroundSize.height * ratio),
            cornerRadius: Board.tileCornerRadius * ratio).CGPath

        firstBackground = SKSpriteNode(
            texture: view.textureFromNode(firstBackgroundShape),
            color: SKColor.lightGrayColor(),
            size: firstBackgroundSize)

        firstBackground.colorBlendFactor = 1.0
        firstBackground.position = Board.boardPositions[5][0]
        firstBackground.anchorPoint = CGPointZero

        // second background

        let secondBackgroundSize = CGSizeMake(
            firstBackgroundSize.width - Tile.tileSize.width / 4,
            firstBackgroundSize.height - Tile.tileLength / 4)

        var cornerDiff = Board.tileCornerRadius - Tile.tileLength / 8
        let secondBackgroundCorner = (cornerDiff > 0) ? cornerDiff : 0.0

        let secondBackgroundShape = SKShapeNode()
        secondBackgroundShape.fillColor = SKColor.whiteColor()
        secondBackgroundShape.path = UIBezierPath(
            roundedRect: CGRectMake(0, 0, secondBackgroundSize.width * ratio, secondBackgroundSize.height * ratio),
            cornerRadius: secondBackgroundCorner * ratio).CGPath

        secondBackground = SKSpriteNode(
            texture: view.textureFromNode(secondBackgroundShape),
            color: SKColor.whiteColor(),
            size: secondBackgroundSize)

        secondBackground.colorBlendFactor = 1.0
        secondBackground.anchorPoint = CGPointZero
        secondBackground.position = CGPointMake(Tile.tileLength / 8, Tile.tileLength / 8)

        // add middle

        middleBackground = SKSpriteNode(
            color: SKColor.lightGrayColor(),
            size: CGSizeMake(secondBackgroundSize.width, secondBackgroundSize.height / 3))

        middleBackground.anchorPoint = CGPointZero
        middleBackground.position.y = secondBackgroundSize.height / 3

        // add buttons

        let buttonMargin = Tile.tileSize.width / 8
        let buttonHeight = secondBackgroundSize.height / 3 - buttonMargin * 2
        let buttonWidth = (secondBackgroundSize.width - 4 * buttonMargin) / 3

        button1 = SKSpriteNode(color: SKColor.redColor(), size: CGSizeMake(buttonWidth, buttonHeight))
        button2 = SKSpriteNode(color: SKColor.greenColor(), size: CGSizeMake(buttonWidth, buttonHeight))
        button3 = SKSpriteNode(color: SKColor.blueColor(), size: CGSizeMake(buttonWidth, buttonHeight))

        button1.name = ButtonType.Lobby.rawValue
        button2.name = ButtonType.Continue.rawValue
        button3.name = ButtonType.Restart.rawValue

        button1.anchorPoint = CGPointZero
        button2.anchorPoint = CGPointZero
        button3.anchorPoint = CGPointZero

        button1.position.y += buttonMargin
        button2.position.y += buttonMargin
        button3.position.y += buttonMargin

        button1.position.x += buttonMargin
        button2.position.x += buttonMargin * 2 + buttonWidth
        button3.position.x += buttonMargin * 3 + buttonWidth * 2

        // add adButton

        adButton = SKSpriteNode(
            color: SKColor.brownColor(),
            size: CGSizeMake(secondBackgroundSize.width - buttonMargin * 2, secondBackgroundSize.height / 3 - buttonMargin * 2))
        adButton.anchorPoint = CGPointZero
        adButton.position.x += buttonMargin
        adButton.position.y = secondBackgroundSize.height / 3 * 2 + buttonMargin
        adButton.name = ButtonType.Ad.rawValue

        // add top label

        topLabel = SKLabelNode()
        topLabel.text = "Winer!!!"
        topLabel.fontColor = SKColor.lightGrayColor()
        topLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        topLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        topLabel.position.x = adButton.size.width / 2
        topLabel.position.y = adButton.size.height / 2
        topLabel.name = ButtonType.Ad.rawValue

        // add middle label

        middleLabel = SKLabelNode()
        middleLabel.text = "LEVEL 1"
        middleLabel.verticalAlignmentMode = SKLabelVerticalAlignmentMode.Center
        middleLabel.horizontalAlignmentMode = SKLabelHorizontalAlignmentMode.Center
        middleLabel.position.x = secondBackgroundSize.width / 2
        middleLabel.position.y = secondBackgroundSize.height / 6

        // add nodes

        secondBackground.addChild(button1)
        secondBackground.addChild(button2)
        secondBackground.addChild(button3)

        adButton.addChild(topLabel)
        secondBackground.addChild(adButton)

        middleBackground.addChild(middleLabel)
        secondBackground.addChild(middleBackground)

        firstBackground.addChild(secondBackground)
    }

    // MARK: Touches

    override func touchesBegan(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesBegan(touches, withEvent: event)
    }

    override func touchesCancelled(touches: Set<NSObject>!, withEvent event: UIEvent!) {
        super.touchesCancelled(touches, withEvent: event)
    }

    override func touchesEnded(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesEnded(touches, withEvent: event)

        let location = (touches.first as! UITouch).locationInNode(self)
        let node = nodeAtPoint(location)

        if node.name == ButtonType.Lobby.rawValue {
            (scene as! GameScene).goToLobby()
        }

        if node.name == ButtonType.Continue.rawValue {
            (scene as! GameScene).toogleMenu()
        }

        if node.name == ButtonType.Restart.rawValue {
            (scene as! GameScene).restartLevel()
        }

        if node.name == ButtonType.Share.rawValue {
            (scene as! GameScene).share()
        }

        if node.name == ButtonType.Next.rawValue {
            (scene as! GameScene).nextLevel()
        }

        if node.name == ButtonType.Ad.rawValue {
            (scene as! GameScene).showAd()
        }
    }

    override func touchesMoved(touches: Set<NSObject>, withEvent event: UIEvent) {
        super.touchesMoved(touches, withEvent: event)
    }

    enum ButtonType: String {
        case Lobby = "lobby"
        case Continue = "continue"
        case Restart = "restart"
        case Share = "share"
        case Next = "next"
        case Ad = "ad"
    }
}