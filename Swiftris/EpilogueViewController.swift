//
//  EpilogueViewController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-05-22.
//  Copyright (c) 2015 Amanda. All rights reserved.
//

import Foundation
import UIKit

class EpilogueViewController: UIViewController {
    
    @IBOutlet weak var button: UIButton!
    @IBOutlet weak var label: UILabel!
     
    override func viewDidLoad() {
        super.viewDidLoad()
       
        view.backgroundColor = UIColor.lightGrayColor()
  /*
        var highScoreLabel = UILabel(frame: CGRectMake(80, 80, 180, 100))
        highScoreLabel.textAlignment = NSTextAlignment.Center
        highScoreLabel.backgroundColor = UIColor.darkGrayColor()
        highScoreLabel.text = "highScore"
        highScoreLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        highScoreLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(highScoreLabel)
        
        var highLevelLabel = UILabel(frame: CGRectMake(80, 200, 180, 100))
        highLevelLabel.textAlignment = NSTextAlignment.Center
        highLevelLabel.backgroundColor = UIColor.darkGrayColor()
        highLevelLabel.text = "highLevel"
        highLevelLabel.font = UIFont(name: "HelveticaNeue-Bold", size: 16.0)
        highLevelLabel.textColor = UIColor.whiteColor()
        self.view.addSubview(highLevelLabel)
*/
        
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
