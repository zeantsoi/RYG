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
        
    self.keyboardType = UIKeyboardType.DecimalPad
    self.textColor = UIColor.clearColor()
    self.font = UIFont(name: "AvenirNext-DemiBold", size: 40.0)
    self.textAlignment = .Center
      
    self.delegate = self

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    // TODO: this doesn't work, find out why
    let maxLength = 12
    let currentLength = textField.text!.characters.count + string.characters.count - range.length
    return currentLength <= maxLength
  }
  
}