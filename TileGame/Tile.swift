//
//  Tile.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import SpriteKit
import UIKit

protocol TileDragDelegate: class {
    func tileDragBegan(_ tile: Tile, position: CGPoint)
    func tileDragMoved(_ tile: Tile, position: CGPoint)
    func tileDragCancelled(_ tile: Tile, position: CGPoint)
    func tileDragEnded(_ tile: Tile, position: CGPoint)
}

class Tile: SKSpriteNode {

    // MARK: Static Members

    // 6*x+5*(x/8)+2*(x/4)=deviceWidth
    // 6 tiles + 5 spaces + 2 margins = deviceWidth
    static let tileLength: CGFloat = Constants.screenSize.width * 8 / 57
    static let tileSize: CGSize = CGSize(width: tileLength, height: tileLength)
    static let tileCornerRadius: CGFloat = tileLength / 4
    static let tileSpacing: CGFloat = tileLength / 8
    static let starOutlineTexture: SKTexture = SKTexture(imageNamed: "StarOutlined")

    // MARK: Members

    var type: TileType

    var place = (row: 0, column: 0) {
        didSet {
            if let child = childTile {
                child.place = place
            }
        }
    }

    var childTile: Tile? {
        didSet {
            if let tile = childTile {
                tile.position = CGPoint.zero
                tile.setScale(0.5)
                tile.isUserInteractionEnabled = false
                tile.removeFromParent()
                self.removeAllChildren()
                self.addChild(tile)
            }
        }
    }

    weak var tileDragDelegate: TileDragDelegate?
    weak var myScene: GameScene!

    // MARK: Methods - SKSpriteNode

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(row: Int, column: Int, tileType: TileType, delegate: TileDragDelegate) {
        place.row = row
        place.column = column
        type = tileType

        tileDragDelegate = delegate
        myScene = delegate as! GameScene
        
        if type != TileType.hole {

            if tileType == TileType.star {
                super.init(texture: Textures.starTexture, color: Constants.yellowColor, size: Tile.tileSize)
                let outline: SKSpriteNode = SKSpriteNode(texture: Tile.starOutlineTexture, size: Tile.tileSize)
                outline.zPosition = 1
                addChild(outline)
            } else {
                super.init(texture: Textures.tileTexture, color: tileType.tileColor, size: Tile.tileSize)
                isUserInteractionEnabled = true
            }

            colorBlendFactor = 1.0
        } else {
            super.init(texture: nil, color: SKColor.clear, size: Tile.tileSize)
        }
        
        position = GameScene.boardPositions[place.row][place.column]

    }

    // MARK: Touches
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        tileDragDelegate!.tileDragBegan(self, position: touches.first!.location(in: myScene!))
    }
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        tileDragDelegate!.tileDragMoved(self, position: touches.first!.location(in: myScene!))
    }
    
    override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
        tileDragDelegate!.tileDragCancelled(self, position: touches.first!.location(in: myScene!))
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        tileDragDelegate!.tileDragEnded(self, position: touches.first!.location(in: myScene!))
    }
}
