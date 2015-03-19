//
//  GameScene.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-17.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import SpriteKit

// #1 define new constant
let TicklengthLevelOne = NSTimeInterval(600)

class GameScene: SKScene {
    
// #2 define some variables
        var tick:(() -> ())? // a closure which takes no parameters n returne nothing and may be nil
        var tickLengthMillis = TicklengthLevelOne  // current tick length
        var lastTick:NSDate? // last time we experienced a tick
    
    required init(coder aDecoder: NSCoder){
        fatalError("NSCoder not supported")
    }
    
    override init(size: CGSize){
        super.init(size: size)
        
        anchorPoint = CGPoint(x: 0, y: 1.0)
        
        let background = SKSpriteNode(imageNamed: "background")
        background.position = CGPoint (x: 0, y: 0)  //(0,0) is bottom left
        background.anchorPoint = CGPoint(x: 0, y: 1.0) //(0,1) is top left
        addChild(background)
    }
   
    override func update(currentTime: CFTimeInterval) {
        /* Called before each frame is rendered */
        
// #3
        if lastTick == nil {  // in a paused state
            return
        }
        var timePassed = lastTick!.timeIntervalSinceNow * -1000.0 // need + ms value
        if timePassed > tickLengthMillis {  // recover time passed
            lastTick = NSDate()  // report a tick
            tick?()  // if tick !=nil {tick!()}
        }
    }
    
// #4  allow external classes to start or stop ticking
    func startTicking() {
        lastTick = NSDate()
    }
    
    func stopTicking() {
        lastTick = nil
    }
}


