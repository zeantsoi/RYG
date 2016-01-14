//
//  Slider.swift
//  ryg
//
//  Created by Zean Tsoi on 1/8/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation
import UIKit

class Slider: UISlider {
  
  init(frame: CGRect, minimumValue: Float, maximumValue: Float) {
    super.init(frame: frame)

    self.minimumValue = minimumValue
    self.maximumValue = maximumValue
    self.continuous = true
    self.minimumTrackTintColor = UIColor.clearColor()
    self.maximumTrackTintColor = UIColor.clearColor()
    self.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 1.5)

  }

  
  required init?(coder aDecoder: NSCoder) {
      fatalError("init(coder:) has not been implemented")
  }

}