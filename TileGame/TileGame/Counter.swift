//
//  Counter.swift
//  TileGame
//
//  Created by Andrei Luca on 7/17/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

class Counter {

    // MARK: Members

    // timer for counter
    private var timer: NSTimer = NSTimer()

    // you can't change current elapsed time
    var counter: NSTimeInterval = 0

    // interval after timer is invalidated
    var endInterval: NSTimeInterval = 0

    // interval between timer loops
    var loopInterval: NSTimeInterval = 0

    // method called when counterEnd is reached
    var endCallback: (() -> Void)?
    var loopCallback: ((NSTimeInterval) -> Void)?

    // MARK: Counter

    // if end < 0 infinite counter
    init(loopInterval: NSTimeInterval, endInterval: NSTimeInterval, loopCallback: ((NSTimeInterval) -> Void)?, endCallback: (() -> Void)?) {

        self.loopInterval = loopInterval
        self.endInterval = endInterval
        self.endCallback = endCallback
        self.loopCallback = loopCallback
    }

    deinit {
        stopCounter()
    }

    // MARK: Methods

    @objc private func intervalLoop() {

        counter++

        if let call = loopCallback {
            call(counter)
        }

        if endInterval > 0 && counter >= endInterval {
            stopCounter()

            if let call = endCallback {
                call()
            }
        }
    }

    func startCounter() {

        timer = NSTimer.scheduledTimerWithTimeInterval(
            loopInterval, target: self, selector: "intervalLoop", userInfo: nil, repeats: true)
    }

    func pauseCounter() {

        if timer.valid {
            timer.invalidate()
        }
    }

    func stopCounter() {
        
        if timer.valid {
            timer.invalidate()
        }
        counter = 0
    }
}