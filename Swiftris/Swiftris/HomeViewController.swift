//
//  HomeViewController.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-04-08.
//  Copyright (c) 2015 Bloc. All rights reserved.
//


import Foundation
import UIKit

class HomeViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    let pickerData = ["0", "30", "60", "90", "120", "180", "240"]

    @IBOutlet weak var myLabel: UILabel!
    @IBOutlet weak var myPicker: UIPickerView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        myPicker.delegate = self
        myPicker.dataSource = self
    }
    
// Data sources and Delegates
    
    // Data sources
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int{
        return 1
    }

    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int{
        return pickerData.count
    }
    
    // Delegates
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        myLabel.text = pickerData[row]
    }
    
    func pickerView(pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        let titleData = pickerData[row]
        var myTitle = NSAttributedString(string: titleData, attributes:[NSFontAttributeName:UIFont(name:"Avenir light", size: 15.0)!, NSForegroundColorAttributeName: UIColor.blueColor()])
        return myTitle
    }
    
    // to pass pickerView value to timerCount in GameViewController
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        var DestViewController: GameViewController = segue.destinationViewController as! GameViewController
        DestViewController.timerCount = myLabel.text!.toInt()!
    }



}