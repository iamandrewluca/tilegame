//
//  LobbyHeader.swift
//  TileGame
//
//  Created by Andrei Luca on 5/15/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyHeader: UICollectionReusableView {

    // MARK: Members

    static let identifier = "LobbyHeader"

    // MARK: IBOutlets

    @IBOutlet weak var sectionLabel: UILabel!
    @IBOutlet weak var starsLabel: UILabel!

    // MARK: UICollectionReusableView
    
    override func prepareForReuse() {
        sectionLabel.text = ""
        starsLabel.text = ""
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        backgroundColor = Constants.textColor
        sectionLabel.textColor = Constants.backgroundColor
        starsLabel.textColor = Constants.backgroundColor
    }
}
