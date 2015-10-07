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

    private var timerThread: MyThread!

    // timer for counter
    private var timer: NSTimer = NSTimer()

    // you can't change current elapsed time
    var counter: NSTimeInterval = 0

    // interval after timer is invalidated
    var endInterval: NSTimeInterval = 0

    // interval between timer loops
    var loopInterval: NSTimeInterval = 0

    // Internal loop for granular time
    var internalLoopInterval: NSTimeInterval = 0.1
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

    @objc private func run() {
        timer = NSTimer(timeInterval: internalLoopInterval, target: self, selector: "intervalLoop", userInfo: nil, repeats: true)

        let timerRunLoop = NSRunLoop.currentRunLoop()
        timerRunLoop.addTimer(timer, forMode: NSRunLoopCommonModes)
        timerRunLoop.run()
    }

    @objc private func intervalLoop() {

        let shouldCallLoopCallback: Bool = (counter + internalLoopInterval >= floor(counter) + loopInterval)

        counter += internalLoopInterval

        if let call = loopCallback where shouldCallLoopCallback {
            debugPrint("loop")
            call(counter)
        }

        if let call = endCallback where endInterval > 0 && counter >= endInterval {
            debugPrint("end")
            pause()
            call()
        }
    }

    func start() {
//        timerThread = MyThread(target: self, selector: "run", object: nil)
//        timerThread.start()
        timer = NSTimer(timeInterval: internalLoopInterval, target: self, selector: "intervalLoop", userInfo: nil, repeats: true)
        NSRunLoop.currentRunLoop().addTimer(timer, forMode: NSDefaultRunLoopMode)
    }

    /**
    when timer is invalidated, the runLoop of thread where timer was initialized,
    has no more input sources and is terminated which causes also
    thread where timer was initialized to terminate
    */
    func pause() {
        if timer.valid {
            timer.invalidate()
        }
    }

    func stop() {
        pause()
        counter = 0
    }
}