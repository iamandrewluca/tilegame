//
//  Originator.swift
//  TileGame
//
//  Created by Andrei Luca on 5/7/16.
//  Copyright © 2016 Tile Game. All rights reserved.
//

import Foundation

protocol Originator {
    var state: String { get set }

    func set(state: String)
    func saveToMemento()
    func restoreFromMemento(memento: Memento)
}