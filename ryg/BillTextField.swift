//
//  BillTextField.swift
//  ryg
//
//  Created by Zean Tsoi on 1/6/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation
import UIKit

class BillTextField: UITextField, UITextFieldDelegate
{
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    initVars()
  }
  
  
  init(frame: CGRect, value: CGFloat) {
    super.init(frame: frame)
    self.text = String(value)
    initVars()
  }

  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  func initVars() {
    self.keyboardType = UIKeyboardType.DecimalPad
    self.textColor = UIColor.clearColor()
    self.font = UIFont(name: "AvenirNext-DemiBold", size: 40.0)
    self.textAlignment = .Center
    
    self.delegate = self    
  }
  
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    // TODO: limiting character length work, find out why
    let maxLength = 12
    let currentLength = textField.text!.characters.count + string.characters.count - range.length
    return currentLength <= maxLength
  }
  
}