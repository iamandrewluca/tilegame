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
        return (UIImage(named: "Padlock")?.imageWithRenderingMode(UIImageRenderingMode.AlwaysTemplate))!
    }()

    static let identifier: String = "LobbyLockedCell"
    @IBOutlet weak var lockpadImageView: UIImageView!

    // MARK: UICollectionViewCell

    override func awakeFromNib() {
        super.awakeFromNib()

        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = Tile.tileCornerRadius * 2
        layer.masksToBounds = false

        lockpadImageView.image = LobbyLockedCell.padLockImage
        lockpadImageView.tintColor = Constants.textColor
    }



}
