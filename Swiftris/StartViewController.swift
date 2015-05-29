//
//  StartViewController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-05-20.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import UIKit
import GameKit

class StartViewController: UIViewController, GKGameCenterControllerDelegate  {
    
    
//    var gameCenterDelegate: GKGameCenterControllerDelegate!
//    var leaderboardIdentifier: String!
   
 //   var score: Int = 0
 //   var highScore: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()

        authenticateLocalPlayer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleScore:", name: "HandleScore", object: nil)

        // Do any additional setup after loading the view.
    }
    
    @IBAction func leaderboardShow(sender: UIButton) {
        showLeaderboard()

    }


    // initiate game center
    func authenticateLocalPlayer() {
        var localPlayer = GKLocalPlayer.localPlayer()
        localPlayer.authenticateHandler = { (viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                println("GameCenter Player authenticated: \(GKLocalPlayer.localPlayer().authenticated)")
            }
        }
    }


    
/*
    func authenticateLocalPlayer() {
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler? = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                println((GKLocalPlayer.localPlayer().authenticated))
            }
        }
    }
*/
    
func    handleScore(notification: NSNotification) {
        
    }


    // send high score to leaderboard
    func saveHighScore(score:Int) {
        // check if user is signed in
        if GKLocalPlayer.localPlayer().authenticated {
            
            var scoreReporter = GKScore(leaderboardIdentifier: "SwiftrisLeaderBoard_01") // leaderboard ID here
            
            scoreReporter.value = Int64(score) // score variable here
            
            var scoreArray : [GKScore] = [scoreReporter]
            
            GKScore.reportScores(scoreArray, withCompletionHandler: {(error : NSError!) -> Void in
                if error != nil {
                    println("error")
                }
            })
        }
    }


    // shows leaderboard screen
    func showLeaderboard() {
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }

    
    //hides leaderboard screen
    func gameCenterViewControllerDidFinish(gameCenterViewController : GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}


