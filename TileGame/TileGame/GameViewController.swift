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
    
    var section: Int = 0
    var level: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let skView = self.view as! SKView
        
        let scene = GameScene(size: skView.frame.size)

        scene.currentLevel = Level(levelNumber: level, sectionNumber: section)
        
        scene.scaleMode = .AspectFill
        
        skView.showsFPS = true
        skView.showsNodeCount = true
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
