//
//  DescriptionLabel.swift
//  ryg
//
//  Created by Zean Tsoi on 1/7/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation
import UIKit

class DescriptionLabel: UILabel {
  
  override init(frame: CGRect) {
    super.init(frame: frame)

    self.textAlignment = NSTextAlignment.Center
    self.textColor = UIColor.darkGrayColor()
    self.font = UIFont(name: "AvenirNext-DemiBold", size: 24.0)
    self.userInteractionEnabled = true
    self.textAlignment = NSTextAlignment.Right
  }
  
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  
  // Sets the vertical positioning based on order of label
  func updateFrame(index: Int) {
    let yOrigin = CGFloat(52.0)
    let yOffset = CGFloat(45.0)
    let width = CGFloat(160.0)
    let height = CGFloat(24.0)
    
    let offsetForIndex = yOrigin + (yOffset * CGFloat(index))
    self.frame = CGRectMake(18.0, offsetForIndex, width, height)
  }

}
