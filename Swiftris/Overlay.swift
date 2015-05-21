//
//  Overlay.swift
//  Swiftris
//
//  Created by Amanda Pi on 2015-04-12.
//  Copyright (c) 2015 Bloc. All rights reserved.
//

import Foundation
import UIKit

public class LoadingOverlay {
    
    var overlayView = UIView()
    var activityIndicator = UIActivityIndicatorView()
    
    class var shared: LoadingOverlay {
        struct Static {
            static let instance: LoadingOverlay = LoadingOverlay()
        }
        return Static.instance
    }
    
    public func showOverlay(view: UIView) {
        
        overlayView.frame = CGRectMake(0, 0, 200, 400)
        //overlayView.center = view.center
        overlayView.center = CGPointMake(overlayView.bounds.width / 2 + 12, overlayView.bounds.height / 2 + 12)
        overlayView.backgroundColor = UIColor.blackColor()
        overlayView.alpha = 1.0
        overlayView.clipsToBounds = true
        overlayView.layer.cornerRadius = 5
        
        
        activityIndicator.frame = CGRectMake(0, 0, 100, 100)
        activityIndicator.activityIndicatorViewStyle = .WhiteLarge
        activityIndicator.center = CGPointMake(overlayView.bounds.width / 2, overlayView.bounds.height / 2)
        
        overlayView.addSubview(activityIndicator)
        view.addSubview(overlayView)
        
        activityIndicator.startAnimating()
    }
    
    public func hideOverlayView() {
        activityIndicator.stopAnimating()
        overlayView.removeFromSuperview()
    }

}



