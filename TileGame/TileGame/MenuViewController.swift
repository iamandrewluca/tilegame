//
//  MenuViewController.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtons()
    }
    
    @IBAction func soundButtonPressed(sender: AnyObject) {
        println("sound")
    }
    @IBAction func resetButtonPressed(sender: AnyObject) {
        println("reset")
    }
    @IBAction func musicButtonPressed(sender: AnyObject) {
        println("music")
    }
    @IBAction func adsButtonPressed(sender: AnyObject) {
        println("ads")
    }
    @IBAction func shareButtonPressed(sender: AnyObject) {
        println("share")
    }
    @IBAction func rateButtonPressed(sender: AnyObject) {
        println("rate")
    }
    
    func setupButtons() {
        self.soundButton.backgroundColor = Constants.Color1
        self.resetButton.backgroundColor = Constants.Color2
        self.musicButton.backgroundColor = Constants.Color3
        self.adsButton.backgroundColor = Constants.Color4
        self.shareButton.backgroundColor = Constants.Color5
        self.rateButton.backgroundColor = Constants.Color1
        self.playButton.backgroundColor = Constants.Color2
        
        var ratio: CGFloat = 1
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            ratio = 2
        }
        
        let playLayer = CAShapeLayer()
        playLayer.path = UIBezierPath(
            roundedRect: self.playButton.bounds,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSizeMake(30, 30) * ratio).CGPath
        self.playButton.layer.mask = playLayer
        
        let musicLayer = CAShapeLayer()
        musicLayer.path = UIBezierPath(
            roundedRect: self.musicButton.bounds,
            byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.BottomRight | UIRectCorner.TopRight,
            cornerRadii: CGSizeMake(25, 25) * ratio).CGPath
        self.musicButton.layer.mask = musicLayer
        
        let soundLayer = CAShapeLayer()
        soundLayer.path = UIBezierPath(
            roundedRect: self.soundButton.bounds,
            byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.TopLeft | UIRectCorner.BottomRight,
            cornerRadii: CGSizeMake(25, 25) * ratio).CGPath
        self.soundButton.layer.mask = soundLayer
        
        let resetLayer = CAShapeLayer()
        resetLayer.path = UIBezierPath(
            roundedRect: self.resetButton.bounds,
            byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.TopLeft | UIRectCorner.BottomRight,
            cornerRadii: CGSizeMake(20, 20) * ratio).CGPath
        self.resetButton.layer.mask = resetLayer
        
        let shareLayer = CAShapeLayer()
        shareLayer.path = UIBezierPath(
            roundedRect: self.shareButton.bounds,
            byRoundingCorners: UIRectCorner.BottomRight | UIRectCorner.TopRight | UIRectCorner.BottomLeft,
            cornerRadii: CGSizeMake(20, 20) * ratio).CGPath
        self.shareButton.layer.mask = shareLayer
        
        let adsLayer = CAShapeLayer()
        adsLayer.path = UIBezierPath(
            roundedRect: self.adsButton.bounds,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSizeMake(20, 20) * ratio).CGPath
        self.adsButton.layer.mask = adsLayer
        
        let rateLayer = CAShapeLayer()
        rateLayer.path = UIBezierPath(
            roundedRect: self.rateButton.bounds,
            byRoundingCorners: UIRectCorner.BottomRight | UIRectCorner.TopRight | UIRectCorner.TopLeft,
            cornerRadii: CGSizeMake(20, 20) * ratio).CGPath
        self.rateButton.layer.mask = rateLayer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if let identifier = segue.identifier {
            if identifier == Identifiers.lobbySegue {
                println("toLobby")
            }
        }
    }
}
