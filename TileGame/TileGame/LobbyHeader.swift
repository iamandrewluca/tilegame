//
//  LobbyHeader.swift
//  TileGame
//
//  Created by Andrei Luca on 5/15/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import UIKit

class LobbyHeader: UICollectionReusableView {
    @IBOutlet weak var headerLabel: UILabel!
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}
