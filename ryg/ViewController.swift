//
//  ViewController.swift
//  ryg
//
//  Created by Zean Tsoi on 1/3/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {
  
  
  @IBOutlet weak var firstLabel: UILabel!
  @IBOutlet weak var secondLabel: UILabel!
  @IBOutlet weak var thirdLabel: UILabel!
  @IBOutlet weak var fourthLabel: UILabel!
  @IBOutlet weak var fifthLabel: UILabel!
  @IBOutlet weak var sixthLabel: UILabel!
  @IBOutlet weak var seventhLabel: UILabel!
  
  var billLabel:DisplayLabel!
  var tipLabel:DisplayLabel!
  var totalLabel:DisplayLabel!
  var billTextFieldView:BillTextFieldView!
  var settingsViewController:SettingsViewController!
  var sliderButtonImage:UIImage?
  let slider = UISlider()
  let sliderLength = CGFloat(380.0)
  let sliderMinimum = CGFloat(12.0)
  let sliderMaximum = CGFloat(25.0)
  let globalVerticalOffset = CGFloat(50.0)
  let defaultTextColorNumericValue = CGFloat(1.0/3.0)

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
    let viewWidth = self.view.frame.size.width
    let viewHeight = self.view.frame.size.height
    
    // Do any additional setup after loading the view, typically from a nib.
        
    let sliderOriginX = (self.view.frame.width / 2) - 100
    slider.frame = CGRectMake(sliderOriginX, 140 + globalVerticalOffset, sliderLength, 20)
    slider.minimumValue = 12.0
    slider.maximumValue = 25.0
    slider.continuous = true
    slider.minimumTrackTintColor = UIColor.clearColor()
    slider.maximumTrackTintColor = UIColor.clearColor()
    slider.value = ((slider.maximumValue - slider.minimumValue) / 2) + slider.minimumValue
    slider.addTarget(self, action: "sliderValueDidChange:", forControlEvents: .ValueChanged)
    
    self.view.addSubview(slider)
    
    slider.transform = CGAffineTransformMakeRotation(CGFloat(M_PI) * 1.5)
    slider.setThumbImage(sliderButtonImage, forState: UIControlState.Normal)
    firstLabel.text = "PERFECTION"
    secondLabel.text = "9 OUT OF 10"
    thirdLabel.text = "THUMBS UP"
    fourthLabel.text = "SOLID"
    fifthLabel.text = "NOT BAD"
    sixthLabel.text = "EH, MEH"
    seventhLabel.text = "WORST EVER"
    
    labels = [firstLabel,
      secondLabel,
      thirdLabel,
      fourthLabel,
      fifthLabel,
      sixthLabel,
      seventhLabel,
    ]
    
    segmentLength = CGFloat(sliderMaximum - sliderMinimum) / CGFloat(labels.count)
    relativeLength = sliderMaximum - sliderMinimum
    halfSegmentLength = segmentLength / 2.0
    
    
    let lastLabel = labels[labels.count - 1]
    let displayLabelOriginY = lastLabel.frame.origin.y + lastLabel.frame.size.height + 25.0
    
    let displayLabelHeight = CGFloat(55.0)

    billLabel = DisplayLabel(frame: CGRectMake(0.0, displayLabelOriginY, viewWidth, displayLabelHeight))
    let billLabelTap = UITapGestureRecognizer(target: self, action: "billLabelWasTapped:")
    self.billLabel.addGestureRecognizer(billLabelTap)
    self.view.addSubview(billLabel)
    
    tipLabel = DisplayLabel(frame: CGRectMake(0.0, billLabel.frame.origin.y + (displayLabelHeight), viewWidth, displayLabelHeight))
    self.view.addSubview(tipLabel)
    
    totalLabel = DisplayLabel(frame: CGRectMake(0.0, tipLabel.frame.origin.y + (displayLabelHeight), viewWidth, displayLabelHeight))
    self.view.addSubview(totalLabel)

    billTextFieldView = BillTextFieldView(frame: CGRectMake(0.0, 0.0, viewWidth, viewHeight))
    
    self.view.addSubview(billTextFieldView)
    
    let swipeRight = UISwipeGestureRecognizer(target: self, action: "endEditing:")
    let tapped = UITapGestureRecognizer(target: self, action: "endEditing:")
    billTextFieldView.addGestureRecognizer(swipeRight)
    billTextFieldView.addGestureRecognizer(tapped)
    billTextFieldView.billTextField.checkOrAddCurrency()
        
    NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    billTextFieldView.billTextField.delegate = self
    
    let settingsButton = UIView(frame: CGRectMake(0, 400, 20, 20))
    settingsButton.backgroundColor = UIColor.orangeColor()
    let settingsButtonTapped = UITapGestureRecognizer(target: self, action: "settingsButtonTapped:")
    settingsButton.addGestureRecognizer(settingsButtonTapped)
//    self.view.addSubview(settingsButton)
    
    settingsViewController = SettingsViewController()
    
  }
  
  func settingsButtonTapped(sender: UITapGestureRecognizer) {
    print("button tapped")
    settingsViewController.modalTransitionStyle = UIModalTransitionStyle.CrossDissolve;
    settingsViewController.modalPresentationStyle = UIModalPresentationStyle.FullScreen;
    self.presentViewController(settingsViewController, animated: true, completion: nil)
  }
  
  func updateDisplayLabels() {
    let billTextFieldText = String(billTextFieldView.billTextField.text!.characters.dropFirst())
    let billTextFieldFloat: Float! = Float(billTextFieldText)
    if (billTextFieldFloat != nil) {
      let totalFloat = (billTextFieldFloat * (slider.value / 100.0)) + billTextFieldFloat
      
      let numberFormatter = NSNumberFormatter()
      numberFormatter.numberStyle = NSNumberFormatterStyle.CurrencyStyle
      
      billLabel.text = numberFormatter.stringFromNumber(billTextFieldFloat)
      totalLabel.text = numberFormatter.stringFromNumber(totalFloat)
    }
  }
  
  func endEditing(sender: UISwipeGestureRecognizer) {
    animateLabels()
    self.updateDisplayLabels()
    self.becomeFirstResponder()
    animateBillTextField(true)
    self.view.endEditing(true)
  }
  
  func buttonClicked(sender:UIButton)
  {
    UIApplication.sharedApplication().openURL(NSURL(string: UIApplicationOpenSettingsURLString)!)
  }
  
  func billLabelWasTapped(sender: UITapGestureRecognizer) {
    animateBillTextField(false)
  }
    
  func keyboardWillShow(notification: NSNotification) {
    // Get the height of the keyboard
    let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue()
    keyboardHeight = keyboardSize!.height
    // Set the height of the billTextField
    billTextFieldView.frame.size.height = self.view.frame.size.height - keyboardHeight
    billTextFieldView.frameDidAdjust()
  }
  
  
  func animateBillTextField(out: Bool) {
    billTextFieldView.billTextField.becomeFirstResponder()
    UIView.animateWithDuration(0.4, animations: {
      let originX = out ? self.view.frame.size.width : 0.0
        self.billTextFieldView.frame.origin.x = originX
    })
  }
  
  
  
  override func viewDidAppear(animated: Bool) {
    animateBillTextField(false)
    sliderValueDidChange(slider)
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func sliderValueDidChange(sender:UISlider!)
  {
    let currentPosition = CGFloat(sender.value)
    currentRelativePosition = currentPosition - sliderMinimum
    
    // Disallow first and last segments to be selected beyond midway point
    if (currentPosition > sliderMaximum - halfSegmentLength) {
      slider.value = Float(sliderMaximum - halfSegmentLength);
      currentRelativePosition = CGFloat(slider.value) - sliderMinimum
    } else if (currentPosition < sliderMinimum + halfSegmentLength) {
      slider.value = Float(sliderMinimum + halfSegmentLength);
      currentRelativePosition = CGFloat(slider.value) - sliderMinimum
    }
    
    if (sliderLastPosition == 0.0) {
      sliderLastPosition = currentPosition
    }
    
    changeSliderButtonColor()
    animateLabels()
    sliderLastPosition = currentPosition
    
    tipLabel.text = String(format: "%.1f%%", currentPosition)
    tipLabel.textColor = sliderColor
    totalLabel.textColor = sliderColor
    
    self.updateDisplayLabels()
  }
  
  
  func animateLabels() {
    let segmentLength = (sliderMaximum - sliderMinimum) / CGFloat(labels.count)
    currentSegmentIndex = Int(currentRelativePosition / segmentLength)
    if (currentSegmentIndex == labels.count) {
      currentSegmentIndex = currentSegmentIndex - 1
    }

    // If lastLabelAnimatedIndex is nil, set it
    if (lastLabelAnimatedIndex == nil) {
      lastLabelAnimatedIndex = currentSegmentIndex
    }
    
    let currentPositionInSegment = currentRelativePosition - (segmentLength * CGFloat(currentSegmentIndex))
    
    var animationPercentage:CGFloat!
    let halfSegmentLength = segmentLength / 2.0
    if (currentPositionInSegment <= halfSegmentLength) {
      animationPercentage = currentPositionInSegment / halfSegmentLength
    } else {
      animationPercentage = 1.0 - ((currentPositionInSegment - halfSegmentLength) / halfSegmentLength)
    }

    // Ease the slide animation
    let startingOffset = CGFloat(20.0)
    let offsetLength = CGFloat(25.0)
    let labelToAnimate: UILabel = labels.reverse()[currentSegmentIndex] as! UILabel
    labelToAnimate.frame.origin.x = (CGFloat(animationPercentage) * offsetLength) + startingOffset
    
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
        label.frame.origin.x = startingOffset
        label.textColor = UIColor(red: defaultTextColorNumericValue, green: defaultTextColorNumericValue, blue: defaultTextColorNumericValue, alpha: 1.0)
      }      
    }

    lastLabelAnimatedIndex = currentSegmentIndex
  }
  
  func changeSliderButtonColor() {
    var red = defaultTextColorNumericValue
    var green = defaultTextColorNumericValue
    var percentage = CGFloat(0.0)
    let relativeMid = CGFloat((slider.maximumValue - slider.minimumValue) / 2)
    
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
    sliderColor = UIColor(red: red, green: green, blue: 0.0, alpha: 1.0)

    sliderButtonImage = drawSliderButton(sliderColor)
    slider.setThumbImage(sliderButtonImage, forState: UIControlState.Normal)
    
    
  }
  
  func drawSliderButton(buttonColor:UIColor) -> UIImage {
    let size = CGSize(width: 64, height: 70)
    let opaque = false
    let scale: CGFloat = 0
    UIGraphicsBeginImageContextWithOptions(size, opaque, scale)
    let context = UIGraphicsGetCurrentContext()
    
    let lineWidth = CGFloat(4.0)
    CGContextSetLineWidth(context, lineWidth)
    CGContextSetStrokeColorWithColor(context,
      UIColor.whiteColor().CGColor)
    
    let outerCircle = CGRectMake(5, 12, 56, 56)
    CGContextBeginPath(context);
    CGContextAddEllipseInRect(context, outerCircle)
    CGContextStrokePath(context)    
    
    let innerCircle = CGRectInset(outerCircle, 5, 5)
    CGContextSetFillColorWithColor(context, buttonColor.CGColor)
    CGContextAddEllipseInRect(context, innerCircle)
    CGContextFillPath(context)
    
    // Draw the pointer
    CGContextBeginPath(context);
    CGContextRotateCTM(context, CGFloat(M_PI*(-90/180)))
    let triangleRect = CGRectMake(-12, 24, 10, 18)
    CGContextMoveToPoint   (context, CGRectGetMinX(triangleRect), CGRectGetMinY(triangleRect));  // top leftafefe
    CGContextAddLineToPoint(context, CGRectGetMaxX(triangleRect), CGRectGetMidY(triangleRect));  // mid right
    CGContextAddLineToPoint(context, CGRectGetMinX(triangleRect), CGRectGetMaxY(triangleRect));  // bottom left
    CGContextClosePath(context);
    
    CGContextSetRGBFillColor(context, 1, 1, 1, 1);
    CGContextFillPath(context);
    
    
    // Drawing complete, retrieve the finished image and cleanup
    let image = UIGraphicsGetImageFromCurrentImageContext()
    UIGraphicsEndImageContext()
    return image
    
  }
  

//  @IBAction func onTap(sender: AnyObject) {
//    self.view.endEditing(true)
//  }
}

