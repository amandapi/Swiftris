//
//  Classic GameViewController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-17.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation

class ClassicGameViewController: UIViewController, SwiftrisDelegate, UIGestureRecognizerDelegate {
    
    var scene: GameScene!
    var swiftris:Swiftris!
    var panPointReference:CGPoint? // keep track of last point when pan begins
    var player:AVAudioPlayer!
    var isPause: Bool = false
    //var timer = NSTimer()     // for countdown timer
    //var timerCount = Int()   // for countdown timer
   
    @IBOutlet weak var playPauseButton: UIButton!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var levelLabel: UILabel!
    //@IBOutlet weak var countdownLabel: UILabel! // for countdown timer
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    // Register for notification with NSNotificationCenter so that GameViewController will receive applicationWillResignActive notifications
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "swiftrisDidEnterBackground", name: UIApplicationWillResignActiveNotification, object: nil)
        
    // Configure the view
    let skView = view as! SKView // changed as to as!
    skView.multipleTouchEnabled = false
    
    // Create and configure the scene
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
        
// #1 set a closure for the tick property
    scene.tick = didTick
    swiftris = Swiftris()
    swiftris.delegate = self
    swiftris.beginGame()
    
// Present the scene
    skView.presentScene(scene)
        
// play Russian theme song
    let path = NSBundle.mainBundle().pathForResource("theme", ofType:"mp3")
    let fileURL = NSURL(fileURLWithPath: path!)
    player = AVAudioPlayer(contentsOfURL: fileURL, error: nil)
    player.numberOfLoops = -1  // loop theme infinitely
    player.prepareToPlay()
    player.play()

// start countdown
        
    //timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("startCountdown"), userInfo: nil, repeats: true)
}

    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    @IBAction func playPause(sender: UIButton) {
        setPaused(!isPause)
    }
    
    func setPaused(paused: Bool) {
        isPause = paused
        
        if isPause {
            
            scene.stopTicking()
/*
            timer.invalidate()
*/
            player.pause()
            LoadingOverlay.shared.showOverlay(self.view)  // calling Overlay.swift
            playPauseButton.setImage(UIImage(named: "play"), forState: UIControlState.Normal)
        } else {
            LoadingOverlay.shared.hideOverlayView() // calling Overlay.swift
            scene.startTicking()
            player.play()
            //startCountdown()
            //timer = NSTimer.scheduledTimerWithTimeInterval(1, target: self, selector: Selector("startCountdown"), userInfo: nil, repeats: true)
            playPauseButton.setImage(UIImage(named: "pause"), forState: UIControlState.Normal)
        }
    }
    
// #3 lower falling shape by 1 row then asks GameScene to redraw shape at new location
    
    @IBAction func didTap(sender: UITapGestureRecognizer) {
        if (isPause){
            return
        }
            swiftris.rotateShape()
    }
    
    @IBAction func didPan(sender: UIPanGestureRecognizer) {
        if (isPause){
            return
        }
        let currentPoint = sender.translationInView(self.view) // measure of translation distance
        if let originalPoint = panPointReference {
            if abs(currentPoint.x - originalPoint.x) > (BlockSize * 0.9) {
                if sender.velocityInView(self.view).x > CGFloat(0) { 
                    swiftris.moveShapeRight()
                    panPointReference = currentPoint
                } else {
                    swiftris.moveShapeLeft()
                    panPointReference = currentPoint
                }
            }
        } else if sender.state == .Began {
            panPointReference = currentPoint
        }
    }
    
    @IBAction func didSwipe(sender: UISwipeGestureRecognizer) {
        if (isPause){
            return
        }
        swiftris.dropShape()
    }
    
    // Notification
    
    func swiftrisDidEnterBackground() {  // read with NSNotification
        setPaused(true)
        
        NSLog("From GameViewController: swiftrisDidEnterBackground")
    }
   
    // let all gesture recognizer work together but sometimes they might collide
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWithGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    // optional cast priorities: tap, pan, swipe
    func gestureRecognizer(gestureRecognizer: UIGestureRecognizer, shouldBeRequiredToFailByGestureRecognizer otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        if let swipeRec = gestureRecognizer as? UISwipeGestureRecognizer {
            if let panRec = otherGestureRecognizer as? UIPanGestureRecognizer {
                return true
            }
        } else if let panRec = gestureRecognizer as? UIPanGestureRecognizer {
            if let tapRec = otherGestureRecognizer as? UITapGestureRecognizer {
                return true
            }
        }
        return false
    }
    
    func didTick() {
// #4 substitute previous codes
        swiftris.letShapeFall()
    }
    
    func nextShape() {
        let newShapes = swiftris.newShape()
        if let fallingShape = newShapes.fallingShape {
            self.scene.addPreviewShapeToScene(newShapes.nextShape!) {}
            self.scene.movePreviewShape(fallingShape) {
// #5 so we can shut down interaction with the view
                self.view.userInteractionEnabled = true
                self.scene.startTicking()
            }
        }
    }
    
    func gameDidBegin(swiftris: Swiftris) {
        
        levelLabel.text = "\(swiftris.level)"
        scoreLabel.text = "\(swiftris.score)"
        //countdownLabel.text = "\(timerCount)"  // for countdown timer
        scene.tickLengthMillis = TicklengthLevelOne
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
/*  func startCountdown() { // for countdown timer
    
        if timerCount > 0 {
        timerCount -= 1
        countdownLabel.text = "\(timerCount)"
        } else if timerCount == 0 {
            timer.invalidate()
            self.GameOverAlert()
            scene.stopTicking()
            player.stop()
            view.userInteractionEnabled = false
            scene.playSound("gameover.mp3")
            }
        }
*/
    
 /*   func GameOverAlert() {
        
        let alertView = UIAlertController(title: "GAME OVER", message: "You reached level \(swiftris.level) and scored \(swiftris.score)", preferredStyle: .Alert)
        alertView.addAction(UIAlertAction(title: "OK", style: .Cancel, handler: nil))
        alertView.addAction(UIAlertAction(title: "Play again", style: .Default, handler:{(alertAction)-> Void in self.reset()}))
        presentViewController(alertView, animated: true, completion: nil)
    }
*/
    
    func GameOverAlert() {
        // let reveal = SKTransition.flipHorizontalWithDuration(0.5)
        self.presentViewController(EpilogueViewController(), animated: true, completion: nil)
    }
    
    func reset() {
        scene.removeAllChildren()
        scene.stopTicking()
        viewDidLoad()
        //timerCount = 90
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        view.userInteractionEnabled = false
        scene.stopTicking()
        scene.playSound("gameover.mp3")
        // added these 3 lines
        self.GameOverAlert()
        scene.stopTicking()
        player.stop()
        scene.animateCollapsingLines(swiftris.removeAllBlocks(), fallenBlocks: Array<Array<Block>>()) {
        swiftris.beginGame()
        }
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        levelLabel.text = "\(swiftris.level)"
        if scene.tickLengthMillis >= 100 { 
            scene.tickLengthMillis -= 100       // -= 100
        } else if scene.tickLengthMillis <= 50 { // > 50
            scene.tickLengthMillis -= 50        // -= 50
        }
        scene.playSound("levelup.mp3")
    }
    
// stop the ticks, redraw shape at new location, let it drop
    func gameShapeDidDrop(swiftris: Swiftris) {
        scene.stopTicking()
        scene.redrawShape(swiftris.fallingShape!) {
            swiftris.letShapeFall()
        }
        scene.playSound("drop.mp3")
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        self.view.userInteractionEnabled = false
// recover 2 arrays. update score label, animate explosion
        let removedLines = swiftris.removeCompletedLines()
        if removedLines.linesRemoved.count > 0 {
            self.scoreLabel.text = "\(swiftris.score)"
            scene.animateCollapsingLines(removedLines.linesRemoved, fallenBlocks:removedLines.fallenBlocks) {
// recursive call to invoke itself
                self.gameShapeDidLand(swiftris)
            }
            scene.playSound("bomb.mp3")
        } else {
            nextShape()
        }
    }
    
// #6 after a shape has moved, redraw representation sprite at new location
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
}

