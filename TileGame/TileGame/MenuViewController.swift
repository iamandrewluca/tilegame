//
//  MenuViewController.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController {

    // MARK: Members

    var levelsInfo = LevelsInfo.sharedInstance
    var started = false

    // MARK: IBOutlets

    @IBOutlet weak var buttonsHorizontalConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsVerticalConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var adsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var rateButton: UIButton!

    // MARK: IBActions

    @IBAction func soundButtonPressed(sender: AnyObject) {
        debugPrint("sound")
    }
    @IBAction func themeButtonPressed(sender: AnyObject) {
        debugPrint("theme")
    }
    @IBAction func musicButtonPressed(sender: AnyObject) {
        debugPrint("music")
    }
    @IBAction func adsButtonPressed(sender: AnyObject) {
        debugPrint("ads")
    }
    @IBAction func shareButtonPressed(sender: AnyObject) {
        debugPrint("share")
    }
    @IBAction func rateButtonPressed(sender: AnyObject) {
        debugPrint("rate")
    }

    // MARK: UIViewController

    deinit {
        debugPrint("menu deinit")
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        if !started {
            prepareMenu()
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if !started {
            started = true
            animateMenu()
        }
    }

    override func prefersStatusBarHidden() -> Bool {
        return true
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        setupColors()
    }

    override func awakeFromNib() {
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        setupButtons()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: Methods

    private func animateMenu() {

        UIView.animateWithDuration(0.8, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.CurveEaseIn, animations: { [unowned self] in

            self.titleTopConstraint.constant = self.view.frame.height / 4
            self.buttonsHorizontalConstraint.constant = 0
            self.view.layoutIfNeeded()

        }, completion: nil);
    }

    private func prepareMenu() {
        let fifthPart = (self.view.frame.height / 2 - self.buttonsContainer.frame.height) / 2 + self.buttonsContainer.frame.height / 2

        buttonsVerticalConstraint.constant = -fifthPart
        buttonsHorizontalConstraint.constant = self.view.frame.width / 2 + buttonsContainer.frame.width / 2

        titleTopConstraint.constant = -titleLabel.frame.height
    }

    func setupButtons() {

        var sizeRatio: CGFloat = 1
        
        if UIDevice.currentDevice().userInterfaceIdiom == UIUserInterfaceIdiom.Pad {
            sizeRatio = 2
        }
        
        let playLayer = CAShapeLayer()
        playLayer.path = UIBezierPath(
            roundedRect: self.playButton.bounds,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSizeMake(30, 30) * sizeRatio).CGPath
        self.playButton.layer.mask = playLayer
        
        let musicLayer = CAShapeLayer()
        musicLayer.path = UIBezierPath(
            roundedRect: self.musicButton.bounds,
            byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.BottomRight, UIRectCorner.TopRight],
            cornerRadii: CGSizeMake(25, 25) * sizeRatio).CGPath
        self.musicButton.layer.mask = musicLayer
        
        let soundLayer = CAShapeLayer()
        soundLayer.path = UIBezierPath(
            roundedRect: self.soundButton.bounds,
            byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.TopLeft, UIRectCorner.BottomRight],
            cornerRadii: CGSizeMake(25, 25) * sizeRatio).CGPath
        self.soundButton.layer.mask = soundLayer
        
        let resetLayer = CAShapeLayer()
        resetLayer.path = UIBezierPath(
            roundedRect: self.themeButton.bounds,
            byRoundingCorners: [UIRectCorner.BottomLeft, UIRectCorner.TopLeft, UIRectCorner.BottomRight],
            cornerRadii: CGSizeMake(20, 20) * sizeRatio).CGPath
        self.themeButton.layer.mask = resetLayer
        
        let shareLayer = CAShapeLayer()
        shareLayer.path = UIBezierPath(
            roundedRect: self.shareButton.bounds,
            byRoundingCorners: [UIRectCorner.BottomRight, UIRectCorner.TopRight, UIRectCorner.BottomLeft],
            cornerRadii: CGSizeMake(20, 20) * sizeRatio).CGPath
        self.shareButton.layer.mask = shareLayer
        
        let adsLayer = CAShapeLayer()
        adsLayer.path = UIBezierPath(
            roundedRect: self.adsButton.bounds,
            byRoundingCorners: UIRectCorner.AllCorners,
            cornerRadii: CGSizeMake(20, 20) * sizeRatio).CGPath
        self.adsButton.layer.mask = adsLayer
        
        let rateLayer = CAShapeLayer()
        rateLayer.path = UIBezierPath(
            roundedRect: self.rateButton.bounds,
            byRoundingCorners: [UIRectCorner.BottomRight, UIRectCorner.TopRight, UIRectCorner.TopLeft],
            cornerRadii: CGSizeMake(20, 20) * sizeRatio).CGPath
        self.rateButton.layer.mask = rateLayer
    }

    func setupColors() {

        self.view.backgroundColor = Constants.backgroundColor

        self.titleLabel.textColor = Constants.textColor

        self.playButton.backgroundColor = Constants.Color2
        self.themeButton.backgroundColor = Constants.Color4
        self.soundButton.backgroundColor = Constants.Color1
        self.musicButton.backgroundColor = Constants.Color3
        self.adsButton.backgroundColor = Constants.Color2
        self.shareButton.backgroundColor = Constants.Color5
        self.rateButton.backgroundColor = Constants.Color1

        self.playButton.setTitleColor(Constants.darkColor, forState: UIControlState.Normal)
        self.themeButton.setTitleColor(Constants.darkColor, forState: UIControlState.Normal)
        self.soundButton.setTitleColor(Constants.darkColor, forState: UIControlState.Normal)
        self.musicButton.setTitleColor(Constants.darkColor, forState: UIControlState.Normal)
        self.adsButton.setTitleColor(Constants.darkColor, forState: UIControlState.Normal)
        self.shareButton.setTitleColor(Constants.darkColor, forState: UIControlState.Normal)
        self.rateButton.setTitleColor(Constants.darkColor, forState: UIControlState.Normal)
    }
}
