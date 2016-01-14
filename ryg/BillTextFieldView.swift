//
//  BillTextFieldView.swift
//  ryg
//
//  Created by Zean Tsoi on 1/6/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation
import UIKit

class BillTextFieldView: UIView {
  
  // Initialize view elements
  var billTextField:BillTextField!
  var billTextLabel:BillTextLabel!
  
  // Variable to hold text value
  var billTextFieldValue:CGFloat!
  
  // Cursor color is configurable
  var billTextFieldCursorColor:UIColor!
  

  init(frame: CGRect, billAmount: CGFloat) {
    super.init(frame: frame)
    
    billTextFieldValue = billAmount
    
    // Add a view layer that blurs everything it's on top of
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)
    
    // The text field only takes up part of the view;
    // this makes the calculation for size and dimensions
    let textFrame = CGRectMake(0.0, frame.size.height / 2.0, frame.size.width, 40.0)
    if (billTextFieldValue != 0.0) {
      billTextField = BillTextField(frame: textFrame, value: billTextFieldValue)      
      billTextLabel = BillTextLabel(frame: textFrame, value: billTextFieldValue)
    } else {
      billTextField = BillTextField(frame: textFrame)
      billTextLabel = BillTextLabel(frame: textFrame)
    }
    self.addSubview(billTextLabel)
    self.addSubview(billTextField)
    
    billTextField.addTarget(self, action: "billTextFieldEditingChanged:", forControlEvents: .EditingChanged)    
  }
  

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  // Adjusts for the keyboard pop up changing the frame dimensions
  func frameDidAdjust() {
    let newFrame = CGRectMake(0.0, self.frame.size.height / 2.0, self.frame.size.width, 40.0)
    billTextField.frame = newFrame
    billTextLabel.frame = newFrame
  }
  

  // When text field changes, update the text label;
  // this enables the value to be currency formatted
  // even as the value is being edited
  func billTextFieldEditingChanged(sender: BillTextField) {
    if (sender.text != nil) {
      // If text field has a value, it should not be visible;
      // instead, text should be shown in the text label instead
      if let number = NSNumberFormatter().numberFromString(sender.text!) {
        let numberFormatter = NSNumberFormatter()
        numberFormatter.numberStyle = .CurrencyStyle
        billTextLabel.text = numberFormatter.stringFromNumber(CGFloat(number))
        billTextField.tintColor = UIColor.clearColor()

      // Otherwise, show the text field cursor
      } else {
        billTextLabel.text = nil
        billTextField.tintColor = billTextFieldCursorColor
      }      
    }
  }
  
}