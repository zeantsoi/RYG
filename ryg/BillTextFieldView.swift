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
  
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    let blurEffect = UIBlurEffect(style: UIBlurEffectStyle.Light)
    let blurEffectView = UIVisualEffectView(effect: blurEffect)
    blurEffectView.frame = self.bounds
    blurEffectView.autoresizingMask = [.FlexibleWidth, .FlexibleHeight] // for supporting device rotation
    self.addSubview(blurEffectView)

    
    billTextField = BillTextField(frame: CGRectMake(0.0, frame.size.height / 2.0, frame.size.width, 40.0))
    self.addSubview(billTextField)

    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
  
  func frameDidAdjust() {
    billTextField.frame = CGRectMake(0.0, self.frame.size.height / 2.0, self.frame.size.width, 40.0)
  }
    
}