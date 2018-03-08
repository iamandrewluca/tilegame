//
//  Textures.swift
//  TileGame
//
//  Created by Andrei Luca on 9/23/15.
//  Copyright © 2015 Tile Game. All rights reserved.
//

import Foundation
import SpriteKit

class Textures {

    // MARK: Methods

    fileprivate static var texturesAreCreated: Bool = false

    static var tileTexture: SKTexture!
    static var tileBackgroundTexture: SKTexture!
    static var tileTopTexture: SKTexture!
    static var starTexture: SKTexture!

    static var headerBackgroundTexture: SKTexture!
    static var headerLeftCornerTexture: SKTexture!
    static var headerRightCornerTexture: SKTexture!

    static var menuBackgroundTexture: SKTexture!
    static var menuLeftButtonTexture: SKTexture!
    static var menuMiddleButtonTexture: SKTexture!
    static var menuRightButtonTexture: SKTexture!
    static var menuTopButtonTexture: SKTexture!

    // MARK: Methods

    static func createTextures() {

        if Textures.texturesAreCreated { return }

        debugPrint("generating textures")

        let view: SKView = SKView(frame: UIScreen.main.bounds)

        let screenRatio = Constants.screenRatio

        // tile texture
        let roundRectPath = UIBezierPath(
            roundedRect: CGRect(x: 0, y: 0, width: Tile.tileLength * screenRatio , height: Tile.tileLength * screenRatio),
            cornerRadius: Tile.tileCornerRadius * screenRatio).cgPath

        let tileShape = SKShapeNode()
        tileShape.fillColor = UIColor.white
        tileShape.lineWidth = 0
        tileShape.path = roundRectPath
        tileTexture = view.texture(from: tileShape)

        // tile back texture

        tileShape.fillColor = UIColor.clear
        tileShape.strokeColor = UIColor.white
        tileShape.lineWidth = 1 * Constants.screenRatio
        tileBackgroundTexture = view.texture(from: tileShape)

        // tile top texture

        let roundPath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: Tile.tileSize * screenRatio / 2)).cgPath
        let tileTopShape = SKShapeNode();
        tileTopShape.fillColor = UIColor.white
        tileTopShape.path = roundPath
        tileTopTexture = view.texture(from: tileTopShape)

        // star texture
//        let starPath = getStarPath(0, y: 0, radius: Tile.tileLength / 2 * screenRatio, sides: 5, pointyness: 2)
//        let starShape = SKShapeNode()
//        starShape.fillColor = SKColor.whiteColor()
//        starShape.path = starPath
//        starTexture = view.textureFromNode(starShape)

        starTexture = SKTexture(image: LobbyCell.starImage)

        // menu background texture

        let menuBackgroundSize = CGSize(
            width: GameScene.boardPositions[5][5].x - GameScene.boardPositions[5][0].x,
            height: GameScene.boardPositions[1][0].y - GameScene.boardPositions[5][0].y)

        let menuCornerRadius = Tile.tileLength / 4

        let menuBackgroundPath: UIBezierPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: menuBackgroundSize * screenRatio),
            cornerRadius: menuCornerRadius * screenRatio)

        let menuBackgroundShape = SKShapeNode()
        menuBackgroundShape.fillColor = SKColor.white
        menuBackgroundShape.path = menuBackgroundPath.cgPath
        menuBackgroundTexture = view.texture(from: menuBackgroundShape)

        // buttons textures

        let buttonMargin = Tile.tileSize.width / 4
        let buttonHeight = (menuBackgroundSize.height - buttonMargin * 4) / 3
        let buttonWidth = (menuBackgroundSize.width - buttonMargin * 4) / 3
        let buttonSize: CGSize = CGSize(width: buttonWidth, height: buttonHeight)
        let buttonCornerRadius = menuCornerRadius - Tile.tileLength / 8

        // left button texture

        let leftButtonPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: buttonSize * screenRatio),
            byRoundingCorners: [UIRectCorner.topLeft, UIRectCorner.bottomRight],
            cornerRadii: CGSize(width: buttonCornerRadius * screenRatio, height: buttonCornerRadius * screenRatio))

        let leftButtonShape = SKShapeNode()
        leftButtonShape.fillColor = UIColor.white
        leftButtonShape.path = leftButtonPath.cgPath
        menuLeftButtonTexture = view.texture(from: leftButtonShape)

        // middle button texture

        let middleButtonPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: buttonSize * screenRatio),
            byRoundingCorners: UIRectCorner.allCorners,
            cornerRadii: CGSize(width: buttonCornerRadius * screenRatio, height: buttonCornerRadius * screenRatio))

        let middleButtonShape = SKShapeNode()
        middleButtonShape.fillColor = UIColor.white
        middleButtonShape.path = middleButtonPath.cgPath
        menuMiddleButtonTexture = view.texture(from: middleButtonShape)

        // right button texture

        let rightButtonPath = UIBezierPath(
            roundedRect: CGRect(origin: CGPoint.zero, size: buttonSize * screenRatio),
            byRoundingCorners: [UIRectCorner.bottomLeft, UIRectCorner.topRight],
            cornerRadii: CGSize(width: buttonCornerRadius * screenRatio, height: buttonCornerRadius * screenRatio))

        let rightButtonShape = SKShapeNode()
        rightButtonShape.fillColor = UIColor.white
        rightButtonShape.path = rightButtonPath.cgPath
        menuRightButtonTexture = view.texture(from: rightButtonShape)

        // top button texture

        let topButtonSize: CGSize = CGSize(width: menuBackgroundSize.width - buttonMargin * 2, height: buttonHeight)

        let topButtonPath: UIBezierPath = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: topButtonSize * screenRatio),
            cornerRadius: Tile.tileLength / 2 * screenRatio)
        

        let topButtonShape = SKShapeNode()
        topButtonShape.fillColor = UIColor.white
        topButtonShape.path = topButtonPath.cgPath
        menuTopButtonTexture = view.texture(from: topButtonShape)
        
        Textures.texturesAreCreated = true
    }
}
