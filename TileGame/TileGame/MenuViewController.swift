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

    static let toLobbySegueIdentifier: String = "toLobby"

    var levelsInfo = LevelsInfo.sharedInstance
    var started = false

    // MARK: IBOutlets Buttons

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

    // MARK: Bottom Tiles outlets

    @IBOutlet weak var bottomContainer: UIView!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var tile1: UIView!
    @IBOutlet weak var tile2: UIView!
    @IBOutlet weak var tile3: UIView!
    @IBOutlet weak var tile4: UIView!
    @IBOutlet weak var tile5: UIView!

    // MARK: Random tiles

    @IBOutlet weak var rtile1: UIImageView!
    @IBOutlet weak var rtile2: UIImageView!
    @IBOutlet weak var rtile3: UIImageView!

    // MARK: IBActions

    @IBAction func soundButtonPressed(sender: AnyObject) {
        Settings.toogleSound()
        AudioPlayer.tap()
        debugPrint("sound")
    }
    @IBAction func themeButtonPressed(sender: AnyObject) {
        Settings.toogleTheme()

        if Settings.lightThemeOn {
            debugPrint("Change to light theme")
        } else {
            debugPrint("Change to dark theme")
        }

        AudioPlayer.tap()
        debugPrint("theme")
    }
    @IBAction func musicButtonPressed(sender: AnyObject) {
        Settings.toogleMusic()
        AudioPlayer.tap()
        debugPrint("music")
    }
    @IBAction func adsButtonPressed(sender: AnyObject) {
        AudioPlayer.tap()
        debugPrint("ads")
    }
    @IBAction func shareButtonPressed(sender: AnyObject) {
        AudioPlayer.tap()

        var sharingItems = [AnyObject]()

        // Text
        sharingItems.append("Check out this awesome game!")
        // URL
        sharingItems.append(NSURL(fileURLWithPath: "http://google.com"))
        // Image
        sharingItems.append(UIImage(named: "Star")!)

        let shareVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
        presentViewController(shareVC, animated: true, completion: nil)
    }
    @IBAction func rateButtonPressed(sender: AnyObject) {
        AudioPlayer.tap()

        let appURL: NSURL = NSURL(fileURLWithPath: "http://www.google.com")

        debugPrint(UIApplication.sharedApplication().openURL(appURL))
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
            prepareBottomTiles()
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

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        super.prepareForSegue(segue, sender: sender)

        if segue.identifier == MenuViewController.toLobbySegueIdentifier {
            debugPrint("prepare")
            AudioPlayer.tap()
        }
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
        let fifthPart = self.view.bounds.height / 5

        buttonsVerticalConstraint.constant = -fifthPart
        buttonsHorizontalConstraint.constant = self.view.frame.width / 2 + buttonsContainer.frame.width / 2

        titleTopConstraint.constant = -titleLabel.frame.height
    }

    private func prepareBottomTiles() {
        bottomConstraint.constant -= bottomContainer.bounds.height / 3 * 2

        tile1.layer.cornerRadius = tile1.bounds.height / 3
        tile2.layer.cornerRadius = tile1.bounds.height / 3
        tile3.layer.cornerRadius = tile1.bounds.height / 3
        tile4.layer.cornerRadius = tile1.bounds.height / 3
        tile5.layer.cornerRadius = tile1.bounds.height / 3


        view.layoutIfNeeded()
    }

    func setupButtons() {

        rtile1.layer.cornerRadius = rtile1.bounds.height / 2
        rtile2.layer.cornerRadius = rtile2.bounds.height / 2
        rtile3.layer.cornerRadius = rtile3.bounds.height / 2

        self.playButton.layer.cornerRadius = self.playButton.bounds.height / 4
        self.musicButton.layer.cornerRadius = self.musicButton.bounds.height / 3
        self.soundButton.layer.cornerRadius = self.soundButton.bounds.height / 3
        self.themeButton.layer.cornerRadius = self.themeButton.bounds.height / 3
        self.shareButton.layer.cornerRadius = self.shareButton.bounds.height / 3
        self.adsButton.layer.cornerRadius = self.adsButton.bounds.height / 2
        self.rateButton.layer.cornerRadius = self.rateButton.bounds.height / 3
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

        self.tile1.backgroundColor = Constants.Color1
        self.tile2.backgroundColor = Constants.Color2
        self.tile3.backgroundColor = Constants.Color3
        self.tile4.backgroundColor = Constants.Color4
        self.tile5.backgroundColor = Constants.Color5

        self.rtile1.backgroundColor = Constants.Color2
        self.rtile2.backgroundColor = Constants.Color1
        self.rtile3.backgroundColor = Constants.Color2
    }
}
