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
  
  var billTextField:BillTextField!
  var billTextLabel:BillTextLabel!
  
  var billTextFieldValue:CGFloat!
  
  var billTextFieldCursorColor:UIColor!
  
  init(frame: CGRect, billAmount: CGFloat) {
    super.init(frame: frame)
    
    billTextFieldValue = billAmount
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)
    
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
  
  func frameDidAdjust() {
    let newFrame = CGRectMake(0.0, self.frame.size.height / 2.0, self.frame.size.width, 40.0)
    billTextField.frame = newFrame
    billTextLabel.frame = newFrame
  }
  
  func billTextFieldEditingChanged(sender: BillTextField) {
    if (sender.text != nil) {
      let numberFormatter = NSNumberFormatter()
      numberFormatter.numberStyle = .CurrencyStyle
      if let number = NSNumberFormatter().numberFromString(sender.text!) {
        billTextLabel.text = numberFormatter.stringFromNumber(CGFloat(number))
        billTextField.tintColor = UIColor.clearColor()
      } else {
        billTextLabel.text = nil
        billTextField.tintColor = billTextFieldCursorColor
      }      
    }
  }
  
}