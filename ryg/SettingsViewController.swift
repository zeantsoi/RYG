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
  
  var userDefaults:NSUserDefaults!
  var defaultTip:CGFloat!
  var minTip:CGFloat!
  var maxTip:CGFloat!
  var lightMode:Bool!
  
  var tipPickerView:UIPickerView!
  var tipPercentages:NSMutableArray!
  var percentLabel:UILabel!
  var lightModeSwitch:UISwitch!
  
  init(style: UITableViewStyle, minTipPercent: Float, maxTipPercent: Float) {
    super.init(style: style)
    // Custom initialization
    
    let navigationItem = self.navigationItem
    navigationItem.title = "Configuration"
    
    minTip = CGFloat(minTipPercent)
    maxTip = CGFloat(maxTipPercent)
        
    let percentRange = (Int(minTipPercent)...Int(maxTipPercent))
    tipPercentages = []
    for num in percentRange {
      tipPercentages.addObject(CGFloat(num))
      tipPercentages.addObject(CGFloat(num) + CGFloat(0.5))
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
    
  override func viewDidAppear(animated: Bool) {
    defaultTip = CGFloat(userDefaults.floatForKey("defaultTipPercent"))
    lightMode = userDefaults.boolForKey("lightMode")
    
    
    let indexToSelect = tipPercentages.indexOfObject(defaultTip)
    tipPickerView.selectRow(indexToSelect, inComponent: 0, animated: true)
    pickerView(tipPickerView, didSelectRow: indexToSelect, inComponent: 0)
    
    lightModeSwitch.setOn(lightMode, animated: false)
  }
  
  override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
    let cell = UITableViewCell(style: UITableViewCellStyle.Default, reuseIdentifier: "tableViewCellTemplate")

    // Always reload the latest
    defaultTip = CGFloat(userDefaults.floatForKey("defaultTipPercent"))
    lightMode = userDefaults.boolForKey("lightMode")

    // We'll only have one section, so return unconditionally
    switch (indexPath.row) {
      case 0:
        cell.textLabel!.text = "Light Mode"
      
        lightModeSwitch = UISwitch(frame: CGRectMake(cell.frame.width - 80.0, 6.0, 0, 0))
        lightModeSwitch.on = lightMode
        lightModeSwitch.addTarget(self, action: "lightModeSwitchDidChange:", forControlEvents: UIControlEvents.ValueChanged)
        cell.addSubview(lightModeSwitch)
        
      case 1:
        cell.textLabel!.text = "Default Tip Percentage"

        percentLabel = UILabel(frame: CGRectMake(cell.frame.width - 80.0, 0, 80.0, cell.frame.height))
        percentLabel.textAlignment = NSTextAlignment.Left
        percentLabel.text = "10.0%"
        cell.addSubview(percentLabel)

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
  
  
  override func tableView(tableView: UITableView?, numberOfRowsInSection section: Int) -> Int {
    return 2
  }
  
  
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
