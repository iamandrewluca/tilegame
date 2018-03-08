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

    fileprivate var timerThread: MyThread!

    // timer for counter
    fileprivate var timer: Timer = Timer()

    // you can't change current elapsed time
    var counter: TimeInterval = 0

    // interval after timer is invalidated
    var endInterval: TimeInterval = 0

    // interval between timer loops
    var loopInterval: TimeInterval = 0

    // Internal loop for granular time
    var internalLoopInterval: TimeInterval = 0.1
    // method called when counterEnd is reached
    var endCallback: (() -> Void)?
    var loopCallback: ((TimeInterval) -> Void)?

    // MARK: Counter

    // if end < 0 infinite counter
    init(loopInterval: TimeInterval, endInterval: TimeInterval, loopCallback: ((TimeInterval) -> Void)?, endCallback: (() -> Void)?) {
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

    func run() {
        timer = Timer(timeInterval: internalLoopInterval, target: self, selector: #selector(Counter.intervalLoop), userInfo: nil, repeats: true)

        let timerRunLoop = RunLoop.current
        timerRunLoop.add(timer, forMode: RunLoopMode.commonModes)
        timerRunLoop.run()
    }

    @objc func intervalLoop() {

        let shouldCallLoopCallback: Bool = (counter + internalLoopInterval >= floor(counter) + loopInterval)

        counter += internalLoopInterval

        if let call = loopCallback, shouldCallLoopCallback {
//            debugPrint("loop")
            call(counter)
        }

        if let call = endCallback, endInterval > 0 && counter >= endInterval {
//            debugPrint("end")
            pause()
            call()
        }
    }

    func start() {
//        timerThread = MyThread(target: self, selector: "run", object: nil)
//        timerThread.start()
        timer = Timer(timeInterval: internalLoopInterval, target: self, selector: #selector(Counter.intervalLoop), userInfo: nil, repeats: true)
        RunLoop.current.add(timer, forMode: RunLoopMode.defaultRunLoopMode)
    }

    /**
    when timer is invalidated, the runLoop of thread where timer was initialized,
    has no more input sources and is terminated which causes also
    thread where timer was initialized to terminate
    */
    func pause() {
        if timer.isValid {
            timer.invalidate()
        }
    }

    func stop() {
        pause()
        counter = 0
    }
}
