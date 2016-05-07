//
//  Memento.swift
//  TileGame
//
//  Created by Andrei Luca on 5/7/16.
//  Copyright © 2016 Tile Game. All rights reserved.
//

import Foundation

class Memento {

    let state: String

    init(stateToSave: String) {
        state = stateToSave
    }

    func getSavedState() -> String {
        return state
    }
}