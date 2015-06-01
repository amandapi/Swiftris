//
//  HomeViewController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-05-08.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import UIKit
import GameKit

class HomeViewController: UIViewController, GKGameCenterControllerDelegate  {
    
    var highScore : Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        authenticateLocalPlayer()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "handleScore:", name: "HandleScore", object: nil)
    }
    
    func authenticateLocalPlayer() {
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler? = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                println("(GameCenter) Player authenticated: \(GKLocalPlayer.localPlayer().authenticated)")
            }
        }
    }
    
    func handleScore(notification: NSNotification) () {
        
    }
    
    @IBAction func TimedLeaderboard(sender: UIButton) {
        showHighScore()
        showTimedLeaderboard()
    }

    func showHighScore() {
        if GKLocalPlayer.localPlayer().authenticated {
            let gkScore = GKScore(leaderboardIdentifier: "Swiftris.Amanda.Leaderboard.01")
            //gkScore.value = Swiftris.score
            GKScore.reportScores([gkScore], withCompletionHandler: ({(error: NSError!) -> Void in
                if (error != nil) {
                // handle error
                println("Error: " + error.localizedDescription);
                } else {
                println("Score reported: \(gkScore.value)")
                }
            }))
        }
    }
    
    func showTimedLeaderboard() {
        var vc = self.view?.window?.rootViewController
        var gc = GKGameCenterViewController()
        gc.gameCenterDelegate = self
        vc?.presentViewController(gc, animated: true, completion: nil)
    }
    
    func gameCenterViewControllerDidFinish(gameCenterViewController: GKGameCenterViewController!) {
        gameCenterViewController.dismissViewControllerAnimated(true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
