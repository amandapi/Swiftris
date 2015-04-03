//
//  GameScene.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-17.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import SpriteKit

// #1 define new constant

let BlockSize: CGFloat = 20.0  // the lower resolution
let TicklengthLevelOne = NSTimeInterval(800) // less is faster

class GameScene: SKScene {
    
// #2 define some variables
    
    let gameLayer = SKNode()  // gives offset from edge of screen
    let shapeLayer = SKNode()  // shapeLayer on top, gameLayer middle, background visual bottom
    let LayerPosition = CGPoint(x: 6, y: -6)
    
    var tick:(() -> ())? // a closure which takes no parameters n returne nothing and may be nil
    var tickLengthMillis = TicklengthLevelOne  // current tick length
    var lastTick:NSDate? // last time we experienced a tick
    
    var textureCache = Dictionary<String, SKTexture>()
    
    
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
        
        addChild(gameLayer)
        
        let gameBoardTexture = SKTexture(imageNamed: "gameboard")
        let gameBoard = SKSpriteNode(texture: gameBoardTexture, size: CGSizeMake(BlockSize * CGFloat(NumColumns), BlockSize * CGFloat(NumRows)))
        gameBoard.anchorPoint = CGPoint(x:0, y:1.0)
        gameBoard.position = LayerPosition
        
        shapeLayer.position = LayerPosition
        shapeLayer.addChild(gameBoard)
        gameLayer.addChild(shapeLayer)
        
//runAction(SKAction.repeatActionForever(SKAction.playSoundFileNamed("theme.mp3", waitForCompletion: true))) // set up looping sound playback action for Russian theme song -- better use AVFoundation instead of SKAction
    }
    
    func playSound(sound:String) { // method for GameViewController to play any sound file on demand
        runAction(SKAction.playSoundFileNamed(sound, waitForCompletion: false))
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
    
// #5 most important function to return precise coordinate of block position
    func pointForColumn(column: Int, row: Int) -> CGPoint {
        let x: CGFloat = LayerPosition.x + (CGFloat(column) * BlockSize) + (BlockSize / 2)
        let y: CGFloat = LayerPosition.y - ((CGFloat(row) * BlockSize) + (BlockSize / 2))
        return CGPointMake(x, y)
    }

// #6 use a dictionary to store copies of reusable onjects
    func addPreviewShapeToScene(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {

            var texture = textureCache[block.spriteName]
            if texture == nil {
                texture = SKTexture(imageNamed: block.spriteName)
                textureCache[block.spriteName] = texture
            }
            let sprite = SKSpriteNode(texture: texture)
// #7 start in row -2 so preview piece knows earlier
            sprite.position = pointForColumn(block.column, row:block.row - 2)
            shapeLayer.addChild(sprite)
            block.sprite = sprite
            
// Animation
            sprite.alpha = 0
// #8 to move and redraw each block for a given shape
            let moveAction = SKAction.moveTo(pointForColumn(block.column, row: block.row), duration: NSTimeInterval(0.2))
            moveAction.timingMode = .EaseOut
            let fadeInAction = SKAction.fadeAlphaTo(0.7, duration: 0.4)  // 70% opacity
            fadeInAction.timingMode = .EaseOut
            sprite.runAction(SKAction.group([moveAction, fadeInAction]))
        }
        runAction(SKAction.waitForDuration(0.4), completion: completion)
    }
    
    func movePreviewShape(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.2)
            moveToAction.timingMode = .EaseOut
            sprite.runAction(
                SKAction.group([moveToAction, SKAction.fadeAlphaTo(1.0, duration: 0.2)]), completion:nil)
        }
        runAction(SKAction.waitForDuration(0.2), completion: completion)
    }
    
    func redrawShape(shape:Shape, completion:() -> ()) {
        for (idx, block) in enumerate(shape.blocks) {
            let sprite = block.sprite!
            let moveTo = pointForColumn(block.column, row:block.row)
            let moveToAction:SKAction = SKAction.moveTo(moveTo, duration: 0.05)
            moveToAction.timingMode = .EaseOut
            sprite.runAction(moveToAction, completion: nil)
        }
        runAction(SKAction.waitForDuration(0.05), completion: completion)
    }
    
// animation for flair
    
// take in the tuple data which swiftris returns each line is removed
    func animateCollapsingLines(linesToRemove: Array<Array<Block>>, fallenBlocks: Array<Array<Block>>, completion:() -> ()) {
        var longestDuration: NSTimeInterval = 0
// #2 iterate blocks from left toright, column by column, block by block
        for (columnIdx, column) in enumerate(fallenBlocks) {
            for (blockIdx, block) in enumerate(column) {
                let newPosition = pointForColumn(block.column, row: block.row)
                let sprite = block.sprite!
// #3 a directly proportional delay to look good
                let delay = (NSTimeInterval(columnIdx) * 0.05) + (NSTimeInterval(blockIdx) * 0.05)
                let duration = NSTimeInterval(((sprite.position.y - newPosition.y) / BlockSize) * 0.1)
                let moveAction = SKAction.moveTo(newPosition, duration: duration)
                moveAction.timingMode = .EaseOut
                sprite.runAction(
                    SKAction.sequence([
                        SKAction.waitForDuration(delay),
                        moveAction]))
                longestDuration = max(longestDuration, duration + delay)
            }
        }
        
        for (rowIdx, row) in enumerate(linesToRemove) {
            for (blockIdx, block) in enumerate(row) {
// #4 when removing lines, we make blocks shoot off like explosive debris with UIBezierPath
                let randomRadius = CGFloat(UInt(arc4random_uniform(400) + 100))
                let goLeft = arc4random_uniform(100) % 2 == 0
                
                var point = pointForColumn(block.column, row: block.row)
                point = CGPointMake(point.x + (goLeft ? -randomRadius : randomRadius), point.y)
                
                let randomDuration = NSTimeInterval(arc4random_uniform(2)) + 0.5
// #5 choose beginning angles using radians
                var startAngle = CGFloat(M_PI)
                var endAngle = startAngle * 2
                if goLeft {
                    endAngle = startAngle
                    startAngle = 0
                }
                let archPath = UIBezierPath(arcCenter: point, radius: randomRadius, startAngle: startAngle, endAngle: endAngle, clockwise: goLeft)
                let archAction = SKAction.followPath(archPath.CGPath, asOffset: false, orientToPath: true, duration: randomDuration)
                archAction.timingMode = .EaseIn
                let sprite = block.sprite!
// #6 top block animate first
                sprite.zPosition = 100
                sprite.runAction(
                    SKAction.sequence(
                        [SKAction.group([archAction, SKAction.fadeOutWithDuration(NSTimeInterval(randomDuration))]),
                            SKAction.removeFromParent()]))
            }
        }
// #7 run completion after a duration matching the time it will take to drop the last block
        runAction(SKAction.waitForDuration(longestDuration), completion:completion)
    }
    
}

