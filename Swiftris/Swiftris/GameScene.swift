//
//  GameScene.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-03-17.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
    
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
    }
}


