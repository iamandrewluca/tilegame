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

    // MARK: UIViewController

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        skView.showsFPS = true
        skView.showsNodeCount = true

        let scene = GameScene(size: skView.frame.size)
        scene.scaleMode = SKSceneScaleMode.AspectFill
        scene.level = level

        skView.presentScene(scene)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
}
