//
//  GameViewController.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController {

    // MARK: Members

    var level = (section: 0, number: 0)
    var gameScene: GameScene!

    // MARK: UIViewController

    deinit {
        debugPrint("gvc deinit")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true
        skView.ignoresSiblingOrder = true

        gameScene = GameScene(size: skView.frame.size)
        gameScene.parentController = self
        gameScene.scaleMode = SKSceneScaleMode.AspectFill
        gameScene.level = level

        skView.presentScene(gameScene)
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        gameScene.viewDidAppear()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
        debugPrint("memory warning")
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
