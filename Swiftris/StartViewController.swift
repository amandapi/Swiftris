//
//  StartViewController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-05-20.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import UIKit
import GameKit

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        authenticateLocalPlayer()

        // Do any additional setup after loading the view.
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
