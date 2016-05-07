//
//  Caretaker.swift
//  TileGame
//
//  Created by Andrei Luca on 5/7/16.
//  Copyright © 2016 Tile Game. All rights reserved.
//

import Foundation

protocol Caretaker {

    var savedStates: [Memento] { get set }

    func addMemento(memento: Memento)
    func getMemento(index: Int) -> Memento
}