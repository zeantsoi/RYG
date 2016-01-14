//
//  DisplayLabel.swift
//  ryg
//
//  Created by Zean Tsoi on 1/6/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation
import UIKit

class DisplayLabel: UILabel {
  
  override init(var frame: CGRect) {
    frame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width - 20.0, frame.size.height)
    super.init(frame: frame)
    
    self.textAlignment = NSTextAlignment.Center
    self.textColor = UIColor.whiteColor()
    self.font = UIFont(name: "AvenirNext-DemiBold", size: 40.0)
    self.userInteractionEnabled = true
    self.textAlignment = NSTextAlignment.Right
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
}
