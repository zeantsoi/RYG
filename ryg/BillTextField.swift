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
    self.textColor = UIColor.whiteColor()
    self.font = UIFont(name: ".SFUIDisplay-Black", size: 40.0)
    self.backgroundColor = UIColor.clearColor()
    self.textAlignment = .Center
    checkOrAddCurrency()
    self.text = ""
    self.tintColor = UIColor.whiteColor()
      
    self.delegate = self

  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  func textField(textField: UITextField, shouldChangeCharactersInRange range: NSRange, replacementString string: String) -> Bool {
    self.checkOrAddCurrency()
    return true;
  }
  
  func checkOrAddCurrency() {
    var textString = String(self.text!)
    var stringArray = Array(textString.characters)
    if (stringArray.isEmpty == true || stringArray[0] != "$") {
      textString = String("$\(textString)")
    }
    self.text = textString    
  }
}