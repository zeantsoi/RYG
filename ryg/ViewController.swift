//
//  ViewController.swift
//  ryg
//
//  Created by Zean Tsoi on 1/3/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  var userDefaults:NSUserDefaults!
  
  // These should not be configurable at present
  let SLIDER_MINIMUM = CGFloat(12.0)
  let SLIDER_MAXIMUM = CGFloat(25.0)
  
  // Defaults in the event that user default is nil
  var defaultLightMode = false
  var defaultDefaultTipPercent = 18.5
  
  // Variables that can be set from defaults
  var mainBackgroundColor:UIColor!
  var displayLabelTextColor:UIColor!
  var descriptionLabelTextColorValue:CGFloat!
  var buttonViewColor:UIColor!
  var defaultTipPercent:Float!
  var defaultBillAmount:Float!
  
  var firstLabel=DescriptionLabel()
  var secondLabel=DescriptionLabel()
  var thirdLabel=DescriptionLabel()
  var fourthLabel=DescriptionLabel()
  var fifthLabel=DescriptionLabel()
  var sixthLabel=DescriptionLabel()
  var seventhLabel=DescriptionLabel()
  
  var settingsButton:SettingsButton!
  var billLabel:DisplayLabel!
  var tipLabel:DisplayLabel!
  var totalLabel:DisplayLabel!
  var billTextFieldView:BillTextFieldView!
  var settingsViewController:SettingsViewController!
  var sliderButtonImage:UIImage?
  var slider:Slider!
  let defaultTextColorNumericValue = CGFloat(1.0/3.0)
  let leftBoundOffset = CGFloat(18.0)
  
  var sliderLastPosition = CGFloat(0.0)
  var lastLabelAnimatedIndex:Int!
  
  var labels:NSMutableArray!
  var sliderColor:UIColor!
  var segmentLength:CGFloat!
  var halfSegmentLength:CGFloat!
  var currentSegmentIndex:Int!
  var relativeLength:CGFloat!
  var currentRelativePosition:CGFloat!
  var keyboardHeight = CGFloat(0.0)
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    userDefaults = NSUserDefaults.standardUserDefaults()
    setFromDefaults()
    
    self.view.backgroundColor = UIColor.whiteColor()
    // Do any additional setup after loading the view, typically from a nib.
    
    // Grab controller view dimensions for convenience
    let viewWidth = self.view.frame.width
    let viewHeight = self.view.frame.height

    // Initialize slider
    slider = Slider(frame: CGRectMake(60.0, 190.0, 380.0, 20), minimumValue: Float(SLIDER_MINIMUM), maximumValue: Float(SLIDER_MAXIMUM))
    slider.value = defaultTipPercent
    slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    slider.setThumbImage(sliderButtonImage, forState: UIControlState.Normal)
    self.view.addSubview(slider)
    
    // Initialize description labels
    labels = [
      firstLabel,
      secondLabel,
      thirdLabel,
      fourthLabel,
      fifthLabel,
      sixthLabel,
      seventhLabel,
    ]
    
    let labelNames = [
      "PERFECTION",
      "9 OUT OF 10",
      "THUMBS UP",
      "SOLID",
      "NOT BAD",
      "EH, MEH",
      "WORST EVER",
    ]

    for (index, label) in (labels as NSArray as! [DescriptionLabel]).enumerate() {
      label.updateFrame(index)
      label.text = labelNames[index]
      self.view.addSubview(label)
    }

    // Set some convenience class variables
    segmentLength = CGFloat(SLIDER_MAXIMUM - SLIDER_MINIMUM) / CGFloat(labels.count)
    relativeLength = CGFloat(SLIDER_MINIMUM - SLIDER_MINIMUM)
    halfSegmentLength = segmentLength / 2.0

    // Calculate positioning of display labels
    let lastLabel = labels[labels.count - 1]
    let displayLabelOriginY = lastLabel.frame.origin.y + lastLabel.frame.size.height + 25.0
    let displayLabelHeight = CGFloat(55.0)
    
    // Initialize bill label
    billLabel = DisplayLabel(frame: CGRectMake(0.0, displayLabelOriginY, viewWidth, displayLabelHeight))
    let billLabelTap = UITapGestureRecognizer(target: self, action: "billLabelWasTapped:")
    self.billLabel.addGestureRecognizer(billLabelTap)
    self.view.addSubview(billLabel)
    
    // Initialize tip label
    tipLabel = DisplayLabel(frame: CGRectMake(0.0, billLabel.frame.origin.y + (displayLabelHeight), viewWidth, displayLabelHeight))
    self.view.addSubview(tipLabel)
    
    // Initialize total label
    totalLabel = DisplayLabel(frame: CGRectMake(0.0, tipLabel.frame.origin.y + (displayLabelHeight), viewWidth, displayLabelHeight))
    self.view.addSubview(totalLabel)
    
    // Initialize settings button
    let settingsButtonDimension = CGFloat(40.0)
    let settingsButtonInset = CGFloat(20.0)
    settingsButton = SettingsButton(frame: CGRectMake(0.0 + settingsButtonInset, viewHeight - settingsButtonDimension - settingsButtonInset, settingsButtonDimension, settingsButtonDimension), strokeColorFromDefault: buttonViewColor)
    let settingsButtonTapped = UITapGestureRecognizer(target: self, action: "settingsButtonTapped:")
    settingsButton.addGestureRecognizer(settingsButtonTapped)
    self.view.addSubview(settingsButton)
    
    // Temporarily bypass setting of persistent vars
    defaultBillAmount = 0.0
//      // Set persistent vars
//    setLimitedPersistence()
    
    // Initialize bill text field view
    billTextFieldView = BillTextFieldView(frame: CGRectMake(0.0, 0.0, viewWidth, viewHeight), billAmount: CGFloat(defaultBillAmount))
    let swipeRight = UISwipeGestureRecognizer(target: self, action: "endEditing:")
    let tapped = UITapGestureRecognizer(target: self, action: "endEditing:")
    billTextFieldView.addGestureRecognizer(swipeRight)
    billTextFieldView.addGestureRecognizer(tapped)
    billTextFieldView.billTextField.delegate = self
    // Force billTextFieldView to refresh with defaultBillAmount
    billTextFieldView.billTextFieldEditingChanged(billTextFieldView.billTextField)
    self.view.addSubview(billTextFieldView)
    
    // Initialize settings view controller
    settingsViewController = SettingsViewController(style: UITableViewStyle.Grouped, minTipPercent: slider.minimumValue, maxTipPercent: slider.maximumValue)
    
    // Set notification for keyboard so we can do some math for framing
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)

    // Pop bill text field into view on load
    makeBillTextFieldVisible(true)
  }

  override func viewWillAppear(animated: Bool) {
    self.navigationController?.setNavigationBarHidden(true, animated: false)
    sliderValueDidChange(slider)
    setFromDefaults()
    updateTheme()
  }

  func setFromDefaults() {
    if (userDefaults.objectForKey("lightMode") == nil) {
      userDefaults.setBool(defaultLightMode, forKey: "lightMode")
    }
    if (userDefaults.objectForKey("defaultTipPercent") == nil) {
      userDefaults.setFloat(Float(defaultDefaultTipPercent), forKey: "defaultTipPercent")
    }
    
    let lightMode = userDefaults.boolForKey("lightMode")
    let tipPercent = userDefaults.floatForKey("defaultTipPercent")
    
    defaultTipPercent = tipPercent
    
    if (lightMode) {
      mainBackgroundColor = UIColor.whiteColor()
      displayLabelTextColor = UIColor.lightGrayColor()
      descriptionLabelTextColorValue = CGFloat(2.5 / 3.0)
      buttonViewColor = UIColor(red: descriptionLabelTextColorValue, green: descriptionLabelTextColorValue, blue: descriptionLabelTextColorValue, alpha: 1.0)
    } else {
      mainBackgroundColor = UIColor.blackColor()
      displayLabelTextColor = UIColor.whiteColor()
      descriptionLabelTextColorValue = CGFloat(1.0 / 3.0)
      buttonViewColor = UIColor.whiteColor()
    }
  }
  
  func setLimitedPersistence() {
    // If lastUsed isn't set, or if greater than ten minutes, reset
    if (userDefaults.objectForKey("lastUsed") == nil) || (userDefaults.objectForKey("lastUsed")!.timeIntervalSinceNow > (60 * 10)) {
      userDefaults.setFloat(0.0, forKey: "lastBill")
      defaultBillAmount = 0.0
    } else {
      if (billTextFieldView != nil) {
        if let currentBill = NSNumberFormatter().numberFromString(billTextFieldView.billTextField.text!) {
          userDefaults.setFloat(Float(currentBill), forKey: "lastBillAmount")
        } else {
          userDefaults.setFloat(0.0, forKey: "lastBillAmount")    
        }
      }
      defaultBillAmount = userDefaults.floatForKey("lastBillAmount")
    }
    userDefaults.setObject(NSDate(), forKey: "lastUsed")
  }
  
  func updateTheme() {
    let descriptionLabelTextColor = UIColor(red: descriptionLabelTextColorValue, green: descriptionLabelTextColorValue, blue: descriptionLabelTextColorValue, alpha: 1.0) 
    for label in (labels as NSArray as! [DescriptionLabel]) {
      label.textColor = descriptionLabelTextColor  
    }
    
    totalLabel.textColor = displayLabelTextColor
    tipLabel.textColor = displayLabelTextColor
    billLabel.textColor = displayLabelTextColor
    
    billTextFieldView.billTextFieldCursorColor = displayLabelTextColor 
    billTextFieldView.billTextField.tintColor = displayLabelTextColor
    billTextFieldView.billTextLabel.textColor = displayLabelTextColor
    
    settingsButton.strokeColor = descriptionLabelTextColor
    
    self.view.backgroundColor = mainBackgroundColor
    
    changeSliderButtonColor()
  }
  
  func settingsButtonTapped(sender: UITapGestureRecognizer) {
    self.navigationController?.setNavigationBarHidden(false, animated: false)
    self.navigationController?.pushViewController(settingsViewController, animated: true)
  }
  
  func updateDisplayLabels() {
    let numberFormatter = NSNumberFormatter()
    numberFormatter.numberStyle = .CurrencyStyle
    if let bill = NSNumberFormatter().numberFromString(billTextFieldView.billTextField.text!) {
      billLabel.text = numberFormatter.stringFromNumber(CGFloat(bill))
      let total = CGFloat(bill) * (1 + (sliderLastPosition / 100.0))
      totalLabel.text = numberFormatter.stringFromNumber(CGFloat(total))
    } else {
      billLabel.text = numberFormatter.stringFromNumber(0)
      totalLabel.text = numberFormatter.stringFromNumber(0)      
    }
    
    // Set the display labels
    tipLabel.text = String(format: "%.1f%%", sliderLastPosition)
    tipLabel.textColor = sliderColor
    totalLabel.textColor = sliderColor

  }
  
  func endEditing(sender: UISwipeGestureRecognizer) {
    animateLabels()
    self.updateDisplayLabels()
    self.becomeFirstResponder()
    makeBillTextFieldVisible(false)
    self.view.endEditing(true)
    
    // Since this is the last time a new value is entered,
    // record the time and value in userDefaults
    setLimitedPersistence()
  }
  
  func billLabelWasTapped(sender: UITapGestureRecognizer) {
    makeBillTextFieldVisible(true)
  }
  
  func keyboardWillShow(notification: NSNotification) {
    // Get the height of the keyboard
    let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
    keyboardHeight = keyboardSize!.height
    // Set the height of the billTextField
    billTextFieldView.frame.size.height = self.view.frame.size.height - keyboardHeight
    billTextFieldView.frameDidAdjust()
  }
  
  func makeBillTextFieldVisible(visible: Bool) {
    billTextFieldView.billTextField.becomeFirstResponder()
    UIView.animateWithDuration(0.4, animations: {
      let originX = visible ? 0.0 : self.view.frame.size.width
      self.billTextFieldView.frame.origin.x = originX
    })
  }

  func sliderValueDidChange(sender:Slider!)
  {
    let currentPosition = CGFloat(sender.value)
    // Find the slider position, offset to a minimum of zero
    currentRelativePosition = currentPosition - SLIDER_MINIMUM

    // Disallow first and last segments to be selected beyond midway point
    if (currentPosition > SLIDER_MAXIMUM - halfSegmentLength) {
      slider.value = Float(SLIDER_MAXIMUM - halfSegmentLength);
      currentRelativePosition = CGFloat(slider.value) - SLIDER_MINIMUM
    } else if (currentPosition < SLIDER_MINIMUM + halfSegmentLength) {
      slider.value = Float(SLIDER_MINIMUM + halfSegmentLength);
      currentRelativePosition = CGFloat(slider.value) - SLIDER_MINIMUM
    }
    
    // Disallow invalid values
    if (sliderLastPosition == 0.0) {
      sliderLastPosition = currentPosition
    }
    
    changeSliderButtonColor()
    animateLabels()
    sliderLastPosition = currentPosition

    updateDisplayLabels()
  }
  
  func animateLabels() {
    let segmentLength = (SLIDER_MAXIMUM - SLIDER_MINIMUM) / CGFloat(labels.count)

    // See which indicator the slider is currently pointed to
    currentSegmentIndex = Int(currentRelativePosition / segmentLength)
    if (currentSegmentIndex == labels.count) {
      currentSegmentIndex = currentSegmentIndex - 1
    }
    
    // If lastLabelAnimatedIndex is nil, set it
    // This tracks whether a new segment has been entered
    if (lastLabelAnimatedIndex == nil) {
      lastLabelAnimatedIndex = currentSegmentIndex
    }
    
    // Find where the slider is within a segment
    let currentPositionInSegment = currentRelativePosition - (segmentLength * CGFloat(currentSegmentIndex))
    
    // Math to determine how far to offset current segment description
    var animationPercentage:CGFloat!
    let halfSegmentLength = segmentLength / 2.0
    if (currentPositionInSegment <= halfSegmentLength) {
      animationPercentage = currentPositionInSegment / halfSegmentLength
    } else {
      animationPercentage = 1.0 - ((currentPositionInSegment - halfSegmentLength) / halfSegmentLength)
    }

    // Ease the slide animation
    let offsetLength = CGFloat(25.0)
    let labelToAnimate: UILabel = labels.reverse()[currentSegmentIndex] as! UILabel
    labelToAnimate.frame.origin.x = (CGFloat(animationPercentage) * offsetLength) + leftBoundOffset
    
    // Ease the label color
    let colorComponents = CGColorGetComponents(sliderColor.CGColor)
    let red = colorComponents[0]
    let green = colorComponents[1]
    
    let adjustedRed = ((red - defaultTextColorNumericValue) * animationPercentage) + defaultTextColorNumericValue
    let adjustedGreen = ((green - defaultTextColorNumericValue) * animationPercentage) + defaultTextColorNumericValue
    
    let labelColor = UIColor(red: adjustedRed, green: adjustedGreen, blue: defaultTextColorNumericValue, alpha: 1.0)
    labelToAnimate.textColor = labelColor
    
    // Reset all other labels to the original
    if (lastLabelAnimatedIndex != currentSegmentIndex) {
      for label in (labels as NSArray as! [UILabel]) {
        label.frame.origin.x = leftBoundOffset
        label.textColor = UIColor(red: descriptionLabelTextColorValue, green: descriptionLabelTextColorValue, blue: descriptionLabelTextColorValue, alpha: 1.0)
      }      
    }
    
    lastLabelAnimatedIndex = currentSegmentIndex
  }
  
  func changeSliderButtonColor() {
    var red = defaultTextColorNumericValue
    var green = defaultTextColorNumericValue
    var percentage = CGFloat(0.0)
    let relativeMid = CGFloat((slider.maximumValue - slider.minimumValue) / 2)
    
    // Calculate the RGB value for spectrum between green and red
    if (currentRelativePosition <= relativeMid) {
      red = CGFloat(1.0)
      green = CGFloat(0.0)
      percentage = CGFloat((relativeMid - currentRelativePosition) / (relativeMid - halfSegmentLength))
      green = 1.0 - CGFloat(percentage)
    } else {
      red = CGFloat(0.0)
      green = CGFloat(1.0)
      percentage = CGFloat((currentRelativePosition - relativeMid) / (relativeMid - halfSegmentLength))
      red += (1 - CGFloat(percentage))
    }

    // Update slider button with colored image
    sliderColor = UIColor(red: red, green: green, blue: 0.0, alpha: 1.0)
    sliderButtonImage = drawSliderButton(sliderColor)
    slider.setThumbImage(sliderButtonImage, forState: UIControlState.Normal)
  }
  
  func drawSliderButton(buttonColor:UIColor) -> UIImage {
    let size = CGSize(width: 64, height: 70)
    let opaque = false
    let scale: CGFloat = 0

    // Start of image context
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    let context = UIGraphicsGetCurrentContext()
    
    // Set strokes
    let lineWidth = CGFloat(4.0)
    CGContextSetLineWidth(context, lineWidth)
    CGContextSetStrokeColorWithColor(context,
      buttonViewColor.CGColor)
    
    CGContextBeginPath(context);

    // Draw outer circle
    let outerCircle = CGRectMake(5, 12, 56, 56)
    CGContextAddEllipseInRect(context, outerCircle)
    CGContextStrokePath(context)    
    
    // Draw inner circle
    let innerCircle = CGRectInset(outerCircle, 5, 5)
    CGContextSetFillColorWithColor(context, buttonColor.CGColor)
    CGContextAddEllipseInRect(context, innerCircle)
    CGContextFillPath(context)
    
    // Draw the pointer
    CGContextBeginPath(context);
    CGContextRotateCTM(context, CGFloat(M_PI*(-90/180)))
    let triangleRect = CGRectMake(-12, 24, 10, 18)
    CGContextMoveToPoint(context, CGRectGetMinX(triangleRect), CGRectGetMinY(triangleRect));  // top leftafefe
    CGContextAddLineToPoint(context, CGRectGetMaxX(triangleRect), CGRectGetMidY(triangleRect));  // mid right
    CGContextAddLineToPoint(context, CGRectGetMinX(triangleRect), CGRectGetMaxY(triangleRect));  // bottom left
    CGContextClosePath(context);
    CGContextSetFillColorWithColor(context, buttonViewColor.CGColor)
    CGContextFillPath(context);
    
    // Drawing complete, retrieve the finished image and cleanup
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image    
  }

  @IBAction func onTap(sender: AnyObject) {
    self.view.endEditing(true)
  }
}

