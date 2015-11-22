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

    // MARK: IBOutlets
    
    @IBOutlet weak var levelNumber: UILabel!
    @IBOutlet weak var firstStar: UIImageView!
    @IBOutlet weak var secondStar: UIImageView!
    @IBOutlet weak var thirdStar: UIImageView!

    // MARK: UICollectionViewCell
    
    override func awakeFromNib() {
        super.awakeFromNib()

        layer.cornerRadius = Tile.tileCornerRadius * 2
        layer.masksToBounds = false

        firstStar.image = LobbyCell.starImage
        secondStar.image = LobbyCell.starImage
        thirdStar.image = LobbyCell.starImage

        backgroundColor = Constants.cellBackgroundColor
        levelNumber.textColor = Constants.textColor
        firstStar.tintColor = Constants.noStarColor
        secondStar.tintColor = Constants.noStarColor
        thirdStar.tintColor = Constants.noStarColor
    }

    override func prepareForReuse() {
        firstStar.tintColor = Constants.noStarColor
        secondStar.tintColor = Constants.noStarColor
        thirdStar.tintColor = Constants.noStarColor
        levelNumber.text = "0"
    }
}
