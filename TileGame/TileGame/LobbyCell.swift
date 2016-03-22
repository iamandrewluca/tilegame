//
//  LobbyCell.swift
//  TileGame
//
//  Created by Andrei Luca on 3/30/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyCell: UICollectionViewCell {

    // MARK: Members

    static let identifier = "LobbyCell"

    static let starImage: UIImage = { () -> UIImage in
        return (UIImage(named: "Star")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))!
    }()

    static let starImageOutlined: UIImage = { () -> UIImage in
        return (UIImage(named: "StarOutlined")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))!
    }()

    // MARK: IBOutlets
    
    @IBOutlet weak var levelNumber: UILabel!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!

    // MARK: UICollectionViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.borderWidth = 2
        layer.borderColor = Constants.orangeColor.CGColor
        layer.cornerRadius = bounds.width / 5

        firstStar.image = LobbyCell.starImageOutlined
        secondStar.image = LobbyCell.starImageOutlined
        thirdStar.image = LobbyCell.starImageOutlined

        levelNumber.textColor = Constants.textColor
        prepareForReuse()

    }

    override func prepareForReuse() {

        backgroundColor = Constants.backgroundColor
        firstStar.tintColor = Constants.yellowColor
        secondStar.tintColor = Constants.yellowColor
        thirdStar.tintColor = Constants.yellowColor

        levelNumber.text = "0"
    }
}
