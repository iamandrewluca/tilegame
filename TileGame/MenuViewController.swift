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
    @IBOutlet weak var logoImageView: UIImageView!
    @IBOutlet weak var logoTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var buttonsContainer: UIView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var soundButton: UIButton!
    @IBOutlet weak var soundButtonLabel: UILabel!
    @IBOutlet weak var themeButton: UIButton!
    @IBOutlet weak var musicButton: UIButton!
    @IBOutlet weak var musicButtonLabel: UILabel!
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

    @IBAction func soundButtonPressed(_ sender: AnyObject) {
        Settings.toogleSound()
        self.toogleSoundButtonLook(Settings.soundOn)
        AudioPlayer.tap()
        debugPrint("sound")
    }
    @IBAction func themeButtonPressed(_ sender: AnyObject) {
        Settings.toogleTheme()

        self.toogleTheme(Settings.lightThemeOn)

        AudioPlayer.tap()
        debugPrint("theme")
    }
    @IBAction func musicButtonPressed(_ sender: AnyObject) {
        Settings.toogleMusic()
        self.toogleMusicButtonLook(Settings.musicOn)
        AudioPlayer.tap()
        debugPrint("music")
    }
    @IBAction func adsButtonPressed(_ sender: AnyObject) {
        AudioPlayer.tap()
        debugPrint("ads")
    }
    @IBAction func shareButtonPressed(_ sender: AnyObject) {
        AudioPlayer.tap()

        var sharingItems = [AnyObject]()

        // Text
        sharingItems.append("Check out this awesome game!" as AnyObject)
        // URL
        sharingItems.append(URL(fileURLWithPath: "http://google.com") as AnyObject)
        // Image
        sharingItems.append(UIImage(named: "Star")!)

        let shareVC = UIActivityViewController(activityItems: [], applicationActivities: nil)
        present(shareVC, animated: true, completion: nil)
    }
    @IBAction func rateButtonPressed(_ sender: AnyObject) {
        AudioPlayer.tap()

        let appURL: URL = URL(fileURLWithPath: "http://www.google.com")

        debugPrint(UIApplication.shared.openURL(appURL))
    }

    // MARK: UIViewController

    deinit {
        debugPrint("menu deinit")
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        if !started {
            prepareMenu()
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        if !started {
            started = true
            prepareBottomTiles()
            animateMenu()
        }
    }

    override var prefersStatusBarHidden : Bool {
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

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)

        if segue.identifier == MenuViewController.toLobbySegueIdentifier {
            debugPrint("prepare")
            AudioPlayer.tap()
        }
    }

    // MARK: Methods

    fileprivate func animateMenu() {

        UIView.animate(withDuration: 0.8, delay: 0.5, usingSpringWithDamping: 0.4, initialSpringVelocity: 0.5, options: UIViewAnimationOptions.curveEaseIn, animations: { [unowned self] in

            self.logoTopConstraint.constant = self.view.frame.height / 8
            self.buttonsHorizontalConstraint.constant = 0
            self.view.layoutIfNeeded()

        }, completion: nil);
    }

    fileprivate func prepareMenu() {
        let fifthPart = self.view.bounds.height / 5

        buttonsVerticalConstraint.constant = -fifthPart
        buttonsHorizontalConstraint.constant = self.view.frame.width / 2 + buttonsContainer.frame.width / 2

        logoTopConstraint.constant = -logoImageView.frame.height
    }

    fileprivate func prepareBottomTiles() {
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

        self.soundButtonLabel.clipsToBounds = true
        self.musicButtonLabel.clipsToBounds = true
        self.soundButtonLabel.layer.cornerRadius = self.soundButtonLabel.bounds.width / 2
        self.musicButtonLabel.layer.cornerRadius = self.musicButtonLabel.bounds.width / 2

        let borderWidth: CGFloat = 2
        self.playButton.layer.borderWidth = borderWidth
        self.musicButton.layer.borderWidth = borderWidth
        self.soundButton.layer.borderWidth = borderWidth
        self.soundButtonLabel.layer.borderWidth = borderWidth
        self.musicButtonLabel.layer.borderWidth = borderWidth
        self.themeButton.layer.borderWidth = borderWidth
        self.shareButton.layer.borderWidth = borderWidth
        self.adsButton.layer.borderWidth = borderWidth
        self.rateButton.layer.borderWidth = borderWidth
        rtile1.layer.borderWidth = borderWidth
        rtile2.layer.borderWidth = borderWidth
        rtile3.layer.borderWidth = borderWidth

        self.themeButton.titleLabel?.textAlignment = NSTextAlignment.center
    }

    func setupColors() {
        self.tile1.backgroundColor = Constants.redColor
        self.tile2.backgroundColor = Constants.orangeColor
        self.tile3.backgroundColor = Constants.yellowColor
        self.tile4.backgroundColor = Constants.blueColor
        self.tile5.backgroundColor = Constants.cyanColor

        self.toogleTheme(Settings.lightThemeOn)
    }

    func toogleMusicButtonLook(_ musicOn: Bool) {
        if Settings.musicOn {
            self.musicButton.backgroundColor = Constants.blueColor
            self.musicButton.layer.borderColor = Constants.blueColor.cgColor
            self.musicButton.setTitleColor(Constants.lightColor, for: UIControlState())
            self.musicButtonLabel.backgroundColor = self.musicButton.backgroundColor
            self.musicButtonLabel.layer.borderColor = Constants.lightColor.cgColor
            self.musicButtonLabel.textColor = Constants.lightColor
            self.musicButtonLabel.text = "on"
        } else {
            self.musicButton.backgroundColor = Constants.backgroundColor
            self.musicButton.layer.borderColor = Constants.blueColor.cgColor
            self.musicButton.setTitleColor(Constants.blueColor, for: UIControlState())
            self.musicButtonLabel.backgroundColor = self.musicButton.backgroundColor
            self.musicButtonLabel.layer.borderColor = Constants.blueColor.cgColor
            self.musicButtonLabel.textColor = Constants.blueColor
            self.musicButtonLabel.text = "off"
        }
    }

    func toogleSoundButtonLook(_ soundOn: Bool) {
        if soundOn {
            self.soundButton.backgroundColor = Constants.cyanColor
            self.soundButton.layer.borderColor = Constants.cyanColor.cgColor
            self.soundButton.setTitleColor(Constants.lightColor, for: UIControlState())
            self.soundButtonLabel.backgroundColor = self.soundButton.backgroundColor
            self.soundButtonLabel.layer.borderColor = Constants.lightColor.cgColor
            self.soundButtonLabel.textColor = Constants.lightColor
            self.soundButtonLabel.text = "on"
        } else {
            self.soundButton.backgroundColor = Constants.backgroundColor
            self.soundButton.layer.borderColor = Constants.cyanColor.cgColor
            self.soundButton.setTitleColor(Constants.cyanColor, for: UIControlState())
            self.soundButtonLabel.backgroundColor = self.soundButton.backgroundColor
            self.soundButtonLabel.layer.borderColor = Constants.cyanColor.cgColor
            self.soundButtonLabel.textColor = Constants.cyanColor
            self.soundButtonLabel.text = "off"
        }
    }

    func toogleTheme(_ lightThemeOn: Bool) {

        self.view.backgroundColor = Constants.backgroundColor

        if lightThemeOn {

            self.playButton.backgroundColor = Constants.redColor
            self.themeButton.backgroundColor = Constants.darkColor
            self.adsButton.backgroundColor = Constants.cyanColor
            self.shareButton.backgroundColor = Constants.yellowColor
            self.rateButton.backgroundColor = Constants.orangeColor

            self.rtile1.backgroundColor = Constants.orangeColor
            self.rtile2.backgroundColor = Constants.redColor
            self.rtile3.backgroundColor = Constants.blueColor

            self.playButton.setTitleColor(Constants.lightColor, for: UIControlState())
            self.themeButton.setTitleColor(Constants.lightColor, for: UIControlState())
            self.adsButton.setTitleColor(Constants.lightColor, for: UIControlState())
            self.shareButton.setTitleColor(Constants.lightColor, for: UIControlState())
            self.rateButton.setTitleColor(Constants.lightColor, for: UIControlState())

            self.playButton.layer.borderColor = Constants.redColor.cgColor
            self.themeButton.layer.borderColor = Constants.darkColor.cgColor
            self.adsButton.layer.borderColor = Constants.cyanColor.cgColor
            self.shareButton.layer.borderColor = Constants.yellowColor.cgColor
            self.rateButton.layer.borderColor = Constants.orangeColor.cgColor

            self.rtile1.layer.borderColor = Constants.orangeColor.cgColor
            self.rtile2.layer.borderColor = Constants.redColor.cgColor
            self.rtile3.layer.borderColor = Constants.blueColor.cgColor

            self.toogleSoundButtonLook(Settings.soundOn)
            self.toogleMusicButtonLook(Settings.musicOn)

            self.themeButton.setTitle("Dark Version", for: UIControlState())

            self.logoImageView.image = UIImage(named: "Logo")

        } else {

            self.playButton.backgroundColor = Constants.backgroundColor
            self.themeButton.backgroundColor = Constants.backgroundColor
            self.adsButton.backgroundColor = Constants.backgroundColor
            self.shareButton.backgroundColor = Constants.backgroundColor
            self.rateButton.backgroundColor = Constants.backgroundColor

            self.rtile1.backgroundColor = Constants.backgroundColor
            self.rtile2.backgroundColor = Constants.backgroundColor
            self.rtile3.backgroundColor = Constants.backgroundColor

            self.playButton.setTitleColor(Constants.redColor, for: UIControlState())
            self.themeButton.setTitleColor(Constants.lightColor, for: UIControlState())
            self.adsButton.setTitleColor(Constants.cyanColor, for: UIControlState())
            self.shareButton.setTitleColor(Constants.yellowColor, for: UIControlState())
            self.rateButton.setTitleColor(Constants.orangeColor, for: UIControlState())

            self.playButton.layer.borderColor = Constants.redColor.cgColor
            self.themeButton.layer.borderColor = Constants.lightColor.cgColor
            self.adsButton.layer.borderColor = Constants.cyanColor.cgColor
            self.shareButton.layer.borderColor = Constants.yellowColor.cgColor
            self.rateButton.layer.borderColor = Constants.orangeColor.cgColor

            self.rtile1.layer.borderColor = Constants.orangeColor.cgColor
            self.rtile2.layer.borderColor = Constants.redColor.cgColor
            self.rtile3.layer.borderColor = Constants.blueColor.cgColor

            self.toogleSoundButtonLook(Settings.soundOn)
            self.toogleMusicButtonLook(Settings.musicOn)

            self.themeButton.setTitle("Light Version", for: UIControlState())

            self.logoImageView.image = UIImage(named: "LogoOutlined")

        }
    }
}
