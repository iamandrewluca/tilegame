//
//  FixedSizeStack.swift
//  TileGame
//
//  Created by Andrei Luca on 5/10/16.
//  Copyright © 2016 Tile Game. All rights reserved.
//

import Foundation

class FixedSizeStack<Element> {

    let maxSize: Int

    var items: [Element?] = [Element?]()

    init(size: Int) {
        maxSize = size
    }

    func push(item: Element?) {

        if items.count == maxSize {
            items.removeFirst()
        }

        items.append(item)
    }

    func pop() -> Element? {

        if items.count == 0 {
            return Element?.None
        }

        return items.removeLast()
    }
}