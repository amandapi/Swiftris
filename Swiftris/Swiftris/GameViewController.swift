//
//  GameViewController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-17.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import UIKit
import SpriteKit

class GameViewController: UIViewController, SwiftrisDelegate {
    
    var scene: GameScene!
    var swiftris:Swiftris!

    override func viewDidLoad() {
        super.viewDidLoad()
    
    // Configure the view
    let skView = view as SKView
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

// #2
/*        scene.addPreviewShapeToScene(swiftris.nextShape!) {
            self.swiftris.nextShape?.moveTo(StartingColumn, row: StartingRow)
            self.scene.movePreviewShape(self.swiftris.nextShape!) {
                let nextShapes = self.swiftris.newShape()
                self.scene.startTicking()
                self.scene.addPreviewShapeToScene(nextShapes.nextShape!) {}
            }
        }
*/
}
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
// #3 lower falling shape by 1 row then asks GameScene to redraw shape at new location
    
    func didTick() {
// #4 substitute previous codes
        swiftris.letShapeFall()
        //swiftris.fallingShape?.lowerShapeByOneRow()
        //scene.redrawShape(swiftris.fallingShape!, completion: {})
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
        // The following is false when restarting a new game
        if swiftris.nextShape != nil && swiftris.nextShape!.blocks[0].sprite == nil {
            scene.addPreviewShapeToScene(swiftris.nextShape!) {
                self.nextShape()
            }
        } else {
            nextShape()
        }
    }
    
    func gameDidEnd(swiftris: Swiftris) {
        view.userInteractionEnabled = false
        scene.stopTicking()
    }
    
    func gameDidLevelUp(swiftris: Swiftris) {
        
    }
    
    func gameShapeDidDrop(swiftris: Swiftris) {
        
    }
    
    func gameShapeDidLand(swiftris: Swiftris) {
        scene.stopTicking()
        nextShape()
    }
    
// #6 after a shape has moved, redraw representation sprite at new location
    func gameShapeDidMove(swiftris: Swiftris) {
        scene.redrawShape(swiftris.fallingShape!) {}
    }
    
}
