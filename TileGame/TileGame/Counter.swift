//
//  Counter.swift
//  TileGame
//
//  Created by Andrei Luca on 7/17/15.
//  Copyright (c) 2015 Tile Game. All rights reserved.
//

import Foundation

// TODO: Counter should have time more granular
// because of 1 sec interval you can pause/resume fast and keep time on hold
class Counter {

    // MARK: Members

    // timer for counter
    private var timer: dispatch_source_t!

    // you can't change current elapsed time
    var counter: NSTimeInterval = 0

    // interval after timer is invalidated
    var endInterval: NSTimeInterval = 0

    // interval between timer loops
    var loopInterval: NSTimeInterval = 0

    // Internal loop for granular time
    var internalLoopInterval: NSTimeInterval = 0.0001

    // method called when counterEnd is reached
    var endCallback: (() -> Void)?
    var loopCallback: (NSTimeInterval -> Void)?

    // MARK: Counter

    // if end < 0 infinite counter
    init(loopInterval: NSTimeInterval, endInterval: NSTimeInterval, loopCallback: (NSTimeInterval -> Void)?, endCallback: (() -> Void)?) {

        self.loopInterval = loopInterval
        self.endInterval = endInterval
        self.endCallback = endCallback
        self.loopCallback = loopCallback
    }

    deinit {
        debugPrint("counter deinit")
        stop()
    }

    // MARK: Methods

    @objc private func intervalLoop() {

        if counter + internalLoopInterval > endInterval {
            return
        }

        let shouldCallLoopCallback: Bool = (counter + internalLoopInterval >= floor(counter) + loopInterval)

        counter += internalLoopInterval

        if let call = loopCallback where shouldCallLoopCallback {
            call(counter)
        }

        if let call = endCallback where endInterval > 0 && counter >= endInterval {
            pause()
            call()
        }
    }

    func start() {
        timer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, dispatch_get_main_queue())
        dispatch_source_set_timer(timer, DISPATCH_TIME_NOW, UInt64((1.0 / 5.0) * Double(NSEC_PER_SEC)), UInt64(0.25 * Double(NSEC_PER_SEC)))
        dispatch_source_set_event_handler(timer) {
            debugPrint("repeat")
            self.intervalLoop()
        }

        dispatch_resume(timer)
    }

    func pause() {
        dispatch_source_cancel(timer)
    }

    func stop() {
        pause()
        counter = 0
    }

    func destroy() {
        stop()
        endCallback = nil
        loopCallback = nil
    }
}