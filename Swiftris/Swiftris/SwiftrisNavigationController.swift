//
//  SwiftrisNavigationController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-05-06.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import UIKit
import GameKit

class SwiftrisNavigationController: UINavigationController {

    override func viewDidLoad() {
        //authenticateLocalPlayer()
    }
    
 /*   func authenticateLocalPlayer() {
        
        var localPlayer = GKLocalPlayer.localPlayer()
        
        localPlayer.authenticateHandler = {(viewController, error) -> Void in
            
            if (viewController != nil) {
                self.presentViewController(viewController, animated: true, completion: nil)
            } else {
                println("(GameCenter) Player authenticated: \(GKLocalPlayer.localPlayer().authenticated)")
            }
        }
    }
*/
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
