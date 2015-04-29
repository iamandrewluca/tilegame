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

        // Do any additional setup after loading the view.
        self.soundButton.backgroundColor = Constants.Color1
        self.resetButton.backgroundColor = Constants.Color2
        self.musicButton.backgroundColor = Constants.Color3
        self.adsButton.backgroundColor = Constants.Color4
        self.shareButton.backgroundColor = Constants.Color5
        self.rateButton.backgroundColor = Constants.Color1
        self.playButton.backgroundColor = Constants.Color2
        
        self.playButton.layer.cornerRadius = 20
        
        let musicLayer = CAShapeLayer()
        musicLayer.path = UIBezierPath(
            roundedRect: self.musicButton.bounds,
            byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.BottomRight | UIRectCorner.TopRight,
            cornerRadii: CGSizeMake(20, 20)).CGPath
        self.musicButton.layer.mask = musicLayer
        
        let soundLayer = CAShapeLayer()
        soundLayer.path = UIBezierPath(
            roundedRect: self.soundButton.bounds,
            byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.BottomRight | UIRectCorner.TopLeft,
            cornerRadii: CGSizeMake(20, 20)).CGPath
        self.soundButton.layer.mask = soundLayer
        
        let resetLayer = CAShapeLayer()
        resetLayer.path = UIBezierPath(
            roundedRect: self.resetButton.bounds,
            byRoundingCorners: UIRectCorner.BottomLeft | UIRectCorner.TopRight,
            cornerRadii: CGSizeMake(20, 20)).CGPath
        self.resetButton.layer.mask = resetLayer
        
        let shareLayer = CAShapeLayer()
        shareLayer.path = UIBezierPath(
            roundedRect: self.shareButton.bounds,
            byRoundingCorners: UIRectCorner.BottomRight | UIRectCorner.TopRight | UIRectCorner.BottomLeft,
            cornerRadii: CGSizeMake(10, 10)).CGPath
        self.shareButton.layer.mask = shareLayer
        
        let adsLayer = CAShapeLayer()
        adsLayer.path = UIBezierPath(
            roundedRect: self.adsButton.bounds,
            byRoundingCorners: UIRectCorner.BottomRight | UIRectCorner.TopLeft,
            cornerRadii: CGSizeMake(10, 10)).CGPath
        self.adsButton.layer.mask = adsLayer
        
        let rateLayer = CAShapeLayer()
        rateLayer.path = UIBezierPath(
            roundedRect: self.rateButton.bounds,
            byRoundingCorners: UIRectCorner.BottomRight | UIRectCorner.TopRight | UIRectCorner.TopLeft,
            cornerRadii: CGSizeMake(10, 10)).CGPath
        self.rateButton.layer.mask = rateLayer
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
