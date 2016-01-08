//
//  SettingsButton.swift
//  ryg
//
//  Created by Zean Tsoi on 1/8/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation

class SettingsButton: UIView {
  
  var strokeColor:UIColor!

  init(frame: CGRect, strokeColorFromDefault: UIColor) {
    super.init(frame: frame)
    
    self.backgroundColor = UIColor.clearColor()
    strokeColor = strokeColorFromDefault
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  override func drawRect(rect: CGRect) {
    let context = UIGraphicsGetCurrentContext()
    
    // Set strokes
    let lineWidth = CGFloat(2.0)
    CGContextSetLineWidth(context, lineWidth)
    CGContextSetStrokeColorWithColor(context,
      strokeColor.CGColor)
    
    CGContextBeginPath(context);    
    let inset = CGRectInset(rect, lineWidth * 2, lineWidth * 2)
    CGContextAddEllipseInRect(context, inset)
    CGContextStrokePath(context)    
  }
}
