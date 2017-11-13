//
//  Utility.swift
//  Toast
//
//  Created by Anurag Dake on 04/01/17.
//  Copyright © 2017 Cybrilla Technologies . All rights reserved.
//

import UIKit

/**
 Used to show toast messages.
 */

public class Toast{
    
    public let toastLabel: UILabel!
    public let WIDTH_PADDING: CGFloat = 30.0
    public let HEIGHT_PADDIGN: CGFloat = 25.0
    public let BOTTOM_MARGIN: CGFloat = 140.0
    
    public let toastDuration = 2.0
    public let toastFadeDuration = 1.0
    public let initialAlpha = 0.9
    public let cornerRadius = 15
    public let noOfLines = 2
    
    public init(with message:String, backgroundColor:UIColor = UIColor(colorLiteralRed: 101/255, green: 101/255, blue: 101/255, alpha: 1), textColor:UIColor = UIColor.white) {
        let count = UIApplication.shared.windows.count
        let keyWindow = UIApplication.shared.windows[count-1]
        toastLabel = UILabel(frame: CGRect.zero)
        toastLabel.backgroundColor = backgroundColor
        toastLabel.textColor = textColor
        toastLabel.textAlignment = NSTextAlignment.center;
        toastLabel.text = message
        toastLabel.adjustsFontSizeToFitWidth = true
        toastLabel.alpha = CGFloat(initialAlpha)
        toastLabel.layer.cornerRadius = CGFloat(cornerRadius)
        toastLabel.numberOfLines = noOfLines
        toastLabel.sizeToFit()
        toastLabel.clipsToBounds  =  true
        keyWindow.addSubview(toastLabel)
        
        var toastWidth = toastLabel.frame.width + WIDTH_PADDING
        if toastWidth > (keyWindow.frame.width - WIDTH_PADDING){
            toastWidth = (keyWindow.frame.width - WIDTH_PADDING - 10)
        }
        
        toastLabel.frame = CGRect(x: keyWindow.center.x - (toastWidth/2), y: keyWindow.frame.height - BOTTOM_MARGIN, width: toastWidth, height: toastLabel.frame.height + HEIGHT_PADDIGN)
    }
    
    public func show(){
        UIView.animate(withDuration: toastFadeDuration, delay:toastDuration, options: UIViewAnimationOptions.curveEaseOut, animations: {
            self.toastLabel.alpha = 0.0
        }, completion: { (true) in
            self.toastLabel.removeFromSuperview()
        })
        
        
    }

}
