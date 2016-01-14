//
//  SettingsViewController.swift
//  ryg
//
//  Created by Zean Tsoi on 1/6/16.
//  Copyright © 2016 Zean Tsoi. All rights reserved.
//

import Foundation
import UIKit

class SettingsViewController: UITableViewController, UIPickerViewDataSource, UIPickerViewDelegate {
  
  // User defaults
  var userDefaults:NSUserDefaults!

  // Data passed in from view controller
  var minTip:CGFloat!
  var maxTip:CGFloat!

  // Variables to be saved in settings
  var lightMode:Bool!
  var defaultTip:CGFloat!
  
  // View elements
  var tipPickerView:UIPickerView!
  var percentLabel:UILabel!
  var lightModeSwitch:UISwitch!
  
  // Array to hold possible tip percentages
  var tipPercentages:NSMutableArray!

  
  // Custom init function that enables view controller to pass data
  init(style: UITableViewStyle, minTipPercent: Float, maxTipPercent: Float) {
    super.init(style: style)
    // Custom initialization
    
    let navigationItem = self.navigationItem
    navigationItem.title = "Configuration"
    
    minTip = CGFloat(minTipPercent)
    maxTip = CGFloat(maxTipPercent)
        
    // Initialize array of all percentages with half-steps
    let percentRange = (Int(minTipPercent)...Int(maxTipPercent))
    tipPercentages = []
    for num in percentRange {
      tipPercentages.addObject(CGFloat(num))
      // Don't add a half percent if already at the tip max
      if (Float(num) < maxTipPercent) {
        tipPercentages.addObject(CGFloat(num) + CGFloat(0.5))        
      }
    }
    
  }


  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  

  override func viewDidLoad() {
    super.viewDidLoad()
    
    userDefaults = NSUserDefaults.standardUserDefaults()
  }
  

  override func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
    // We'll only have one section, so return unconditionally
    return "App Settings"
  } 

  
  override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
    return 1
  }
  
  
  override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
    return 2
  }

  
  override func viewDidAppear(animated: Bool) {
    defaultTip = CGFloat(userDefaults.floatForKey("defaultTipPercent"))
    lightMode = userDefaults.boolForKey("lightMode")
    
    // Set picker row to last selected value
    let indexToSelect = tipPercentages.indexOfObject(defaultTip)
    tipPickerView.selectRow(indexToSelect, inComponent: 0, animated: true)
    pickerView(tipPickerView, didSelectRow: indexToSelect, inComponent: 0)
    
    // Set light mode to last selected value
    lightModeSwitch.setOn(lightMode, animated: false)
  }
  
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tableViewCellTemplate")

    // Always reload the latest
    defaultTip = CGFloat(userDefaults.floatForKey("defaultTipPercent"))
    lightMode = userDefaults.boolForKey("lightMode")

    // We'll only have one section, so return unconditionally
    switch (indexPath.row) {
      // Configure light mode switch
      case 0:
        cell.textLabel!.text = "Light Mode"
      
        lightModeSwitch = UISwitch(frame: CGRectMake(cell.frame.width - 80.0, 6.0, 0, 0))
        lightModeSwitch.on = lightMode
        lightModeSwitch.addTarget(self, action: "lightModeSwitchDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        cell.addSubview(lightModeSwitch)
        
      // Configure default tip percentage picker
      case 1:
        cell.textLabel!.text = "Default Tip Percentage"

        percentLabel = UILabel(frame: CGRectMake(cell.frame.width - 80.0, 0, 80.0, cell.frame.height))
        percentLabel.textAlignment = NSTextAlignment.Left
        cell.addSubview(percentLabel)

        // Configure picker view to position right below index row
        let indexPathRect = self.tableView.rectForRowAtIndexPath(indexPath)
        let tipPickerViewFrame = CGRectMake(0.0, indexPathRect.origin.y + cell.frame.height, self.view.frame.size.width, 100.0)
        tipPickerView = UIPickerView(frame: tipPickerViewFrame)
        tipPickerView.delegate = self
        self.view.addSubview(tipPickerView)

      default:
        break
    }

    return cell        
  }
  
  
  func lightModeSwitchDidChange(sender: UISwitch) {
    userDefaults.setBool(lightModeSwitch.on, forKey: "lightMode")    
  }
  
  
  // Remaining classes configure the default tip percentage picker
  
  func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
    return 1
  }
  
  
  func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {                  
    return tipPercentages.count;  
  }
  
  func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
    let tipPercentage = tipPercentages[row] as! CGFloat
    return String(format: "%.1f", tipPercentage)
  }
  
  func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
    let tipPercent = tipPercentages[row] as! CGFloat
    percentLabel.text = String("\(tipPercent)%")
    userDefaults.setFloat(Float(tipPercent), forKey: "defaultTipPercent")
  }
  
}
