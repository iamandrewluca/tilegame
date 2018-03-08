//
//  LobbyLockedCell.swift
//  TileGame
//
//  Created by Andrei Luca on 6/10/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyLockedCell: UICollectionViewCell {

    // MARK: Members

    static let padLockImage: UIImage = { () -> UIImage in
        return (UIImage(named: "Padlock")?.withRenderingMode(UIImageRenderingMode.alwaysTemplate))!
    }()

    static let identifier: String = "LobbyLockedCell"
    @IBOutlet weak var lockpadImageView: UIImageView!

    // MARK: UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()

        var cellColor: UIColor = Constants.lightColor

        if Settings.lightThemeOn {
            cellColor = Constants.orangeColor
        }

        layer.borderWidth = 2
        layer.borderColor = cellColor.cgColor
        layer.cornerRadius = bounds.width / 5

        lockpadImageView.image = LobbyLockedCell.padLockImage
        lockpadImageView.tintColor = cellColor
    }



}
