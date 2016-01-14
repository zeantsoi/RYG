//
//  BillTextLabel.swift
//  ryg
//
//  Created by Zean Tsoi on 1/8/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation
import UIKit

class BillTextLabel: UILabel {
  override init(frame: CGRect) {
    super.init(frame: frame)
    
    initVars()
  }
  
  init(frame: CGRect, value: CGFloat) {
    super.init(frame: frame)
    
    self.text = String(value)
    
    initVars()
  }
  
  func initVars() {
    self.font = UIFont(name: "AvenirNext-DemiBold", size: 40.0)
    self.textAlignment = .Center    
  }

  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }
}