//
//  ViewController.swift
//  Group6MC3
//
//  Created by Faris Ali Yafie on 21/07/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//

import UIKit
import CoreData

class SettingVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate{
    
    let defaults = UserDefaults.standard
    var sound:String?
    var repeated:String?
    var type:String?
    
    let reminder = ReminderController()
    
    @IBOutlet weak var switchAlcohol: UISwitch!
    @IBOutlet weak var switchEat: UISwitch!
    @IBOutlet weak var switchCaffeine: UISwitch!
    @IBOutlet weak var switchExercise: UISwitch!
    @IBOutlet weak var switchSugar: UISwitch!
    @IBOutlet weak var switchGadget: UISwitch!
    @IBOutlet weak var switchBed: UISwitch!
    @IBOutlet weak var switchEncouragement: UISwitch!
    
    @IBOutlet weak var soundLabel: UILabel!
    @IBOutlet weak var editableSound: UITextField!
    @IBOutlet weak var repeatLabel: UILabel!
    @IBOutlet weak var editableRepeat: UITextField!
    @IBOutlet weak var typeLabel: UILabel!
    @IBOutlet weak var editableType: UITextField!
    
    var currentTextField = UITextField()
    var pickerView = UIPickerView()
    
    let soundList = ["Mute","Noise","Calm"]
    let repeatList = ["5 min", "10 min", "15 min", "20 min", "25 min", "30 min"]
    let typeList = ["Tone", "Tone + Vibrate", "Vibrate"]
    
    var setAlarm = [NSManagedObject]()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        reminder.content.sound = .default
        setReminder()
        setTextField()
        editableSound.delegate = self
        editableRepeat.delegate = self
        editableType.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      //1
      guard let appDelegate =
        UIApplication.shared.delegate as? AppDelegate else {
          return
      }
      let managedContext =
        appDelegate.persistentContainer.viewContext
      //2
      let fetchRequest =
        NSFetchRequest<NSManagedObject>(entityName: "Alarm")
      //3
      do {
        setAlarm = try managedContext.fetch(fetchRequest)
      } catch let error as NSError {
        print("Could not fetch. \(error), \(error.userInfo)")
      }
    }
    
    // clear all color and border UITextField
    func setTextField(){
        editableSound.backgroundColor = UIColor.clear
        editableRepeat.backgroundColor = UIColor.clear
        editableType.backgroundColor = UIColor.clear
        editableSound.borderStyle = .none
        editableRepeat.borderStyle = .none
        editableType.borderStyle = .none
        
        // default setting
        if let setSound = defaults.string(forKey: "Sound"){
            editableSound.text = setSound
        }else{
            editableSound.text = soundList[0]
        }
        if let setRepeat = defaults.string(forKey: "Repeated"){
            editableRepeat.text = setRepeat
        }else{
            editableRepeat.text = repeatList[0]
        }
        if let setType = defaults.string(forKey: "Type"){
            editableType.text = setType
        }else{
            editableType.text = typeList[0]
        }
    }
    
    func setReminder(){
        let setAlcohol = defaults.bool(forKey: "Alcohol")
        let setEat = defaults.bool(forKey: "Eat")
        let setCaffeine = defaults.bool(forKey: "Caffeine")
        let setExercise = defaults.bool(forKey: "Exercise")
        let setSugar = defaults.bool(forKey: "Sugar")
        let setGadget = defaults.bool(forKey: "Gadget")
        let setBed = defaults.bool(forKey: "Bed")
        let setEncouragement = defaults.bool(forKey: "Encouragement")
        if setAlcohol == true{
            switchAlcohol.setOn(true, animated: false)
            reminder.cancelAlcoholReminder()
            reminder.avoidAlcoholReminder()
        }
        if setEat == true{
            switchEat.setOn(true, animated: false)
            reminder.cancelEatReminder()
            reminder.avoidEatReminder()
        }
        if setCaffeine == true{
            switchCaffeine.setOn(true, animated: false)
            reminder.cancelCaffeineReminder()
            reminder.avoidFaffeineReminder()
        }
        if setExercise == true{
            switchExercise.setOn(true, animated: false)
            reminder.cancelExerciseReminder()
            reminder.avoidExerciseReminder()
        }
        if setSugar == true{
            switchSugar.setOn(true, animated: false)
            reminder.cancelSugarReminder()
            reminder.avoidSugarReminder()
        }
        if setGadget == true{
            switchGadget.setOn(true, animated: false)
            reminder.cancelGadgetReminder()
            reminder.avoidGadgetReminder()
        }
        if setBed == true{
            switchBed.setOn(true, animated: false)
            reminder.cancelBedReminder()
            reminder.bedTimeReminder()
        }
        if setEncouragement == true{
            switchEncouragement.setOn(true, animated: false)
            reminder.cancelEncouragementReminder()
            reminder.encouragementReminder()
        }
    }
    
    // Start : All Switch Actions
    @IBAction func alcoholSwitched(_ sender: UISwitch) {
        if(switchAlcohol.isOn){
            reminder.avoidAlcoholReminder()
            defaults.set(true, forKey: "Alcohol")
        }else{
            reminder.cancelAlcoholReminder()
            defaults.set(false, forKey: "Alcohol")
        }
    }
    @IBAction func eatSwitched(_ sender: UISwitch) {
        if(switchEat.isOn){
            reminder.avoidEatReminder()
            defaults.set(true, forKey: "Eat")
        }else{
            reminder.cancelEatReminder()
            defaults.set(false, forKey: "Eat")
        }
    }
    @IBAction func caffeineSwitched(_ sender: UISwitch) {
        if(switchCaffeine.isOn){
            reminder.avoidFaffeineReminder()
            defaults.set(true, forKey: "Caffeine")
        }else{
            reminder.cancelCaffeineReminder()
            defaults.set(false, forKey: "Caffeine")
        }
    }
    @IBAction func exerciseSwitched(_ sender: UISwitch) {
        if(switchExercise.isOn){
            reminder.avoidExerciseReminder()
            defaults.set(true, forKey: "Exercise")
        }else{
            reminder.cancelExerciseReminder()
            defaults.set(false, forKey: "Exercise")
        }
    }
    @IBAction func sugarSwitched(_ sender: UISwitch) {
        if(switchSugar.isOn){
            reminder.avoidSugarReminder()
            defaults.set(true, forKey: "Sugar")
        }else{
            reminder.cancelSugarReminder()
            defaults.set(false, forKey: "Sugar")
        }
    }
    @IBAction func gadgetSwitched(_ sender: UISwitch) {
        if(switchGadget.isOn){
            reminder.avoidGadgetReminder()
            defaults.set(true, forKey: "Gadget")
        }else{
            reminder.cancelGadgetReminder()
            defaults.set(false, forKey: "Gadget")
        }
    }
    @IBAction func bedSwitched(_ sender: UISwitch) {
        if(switchBed.isOn){
            reminder.bedTimeReminder()
            defaults.set(true, forKey: "Bed")
        }else{
            reminder.cancelBedReminder()
            defaults.set(false, forKey: "Bed")
        }
    }
    @IBAction func encouragementSwitched(_ sender: UISwitch) {
        if(switchEncouragement.isOn){
            reminder.encouragementReminder()
            defaults.set(true, forKey: "Encouragement")
        }else{
            reminder.cancelEncouragementReminder()
            defaults.set(false, forKey: "Encouragement")
        }
    }
    // End: All Switch Actions
    
    // Start: Alarm Setting
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == editableSound{
            return soundList.count
        }else if currentTextField == editableRepeat{
            return repeatList.count
        }else if currentTextField == editableType{
            return typeList.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == editableSound{
            return soundList[row]
        }else if currentTextField == editableRepeat{
            return repeatList[row]
        }else if currentTextField == editableType{
            return typeList[row]
        }else{
            return ""
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == editableSound{
            editableSound.text = soundList[row]
        }else if currentTextField == editableRepeat{
            editableRepeat.text = repeatList[row]
        }else if currentTextField == editableType{
            editableType.text = typeList[row]
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        var attribute: String?
        if currentTextField == editableSound{
            attribute = soundList[row]
        }else if currentTextField == editableRepeat{
            attribute = repeatList[row]
        }else if currentTextField == editableType{
            attribute = typeList[row]
        }
        return NSAttributedString(string: attribute!, attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        currentTextField = textField
    
        if textField == editableSound{
            editableSound.inputView = pickerView
        } else if textField == editableRepeat{
            editableRepeat.inputView = pickerView
        }else if textField == editableType{
            editableType.inputView = pickerView
        }

        pickerView.backgroundColor = UIColor(red: 42/255, green: 36/255, blue: 57/255, alpha: 1)
        let toolBar = UIToolbar()
        toolBar.barStyle = UIBarStyle.default
        toolBar.isTranslucent = true
        toolBar.tintColor = UIColor(red: 255/255, green: 146/255, blue: 0/255, alpha: 1)
        toolBar.sizeToFit()

        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector (categoryDoneClicked))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        //let cancelButton = UIBarButtonItem(barButtonSystemItem: .cancel, target: nil, action: #selector (categoryDoneClicked)

        toolBar.setItems([spaceButton, doneButton], animated: true)
        toolBar.isUserInteractionEnabled = true
        currentTextField.inputAccessoryView = toolBar
    }
    
    @objc func categoryDoneClicked() {
        currentTextField.inputView = pickerView
        if currentTextField == editableSound{
            self.sound = currentTextField.text!
            self.defaults.set(self.sound, forKey: "Sound")
        }else if currentTextField == editableRepeat{
            self.repeated = currentTextField.text!
            self.defaults.set(self.repeated, forKey: "Repeated")
        }else if currentTextField == editableType{
            self.type = currentTextField.text!
            self.defaults.set(self.type, forKey: "Type")
        }
        self.view.endEditing(true)
    }
    // End: Alarm Setting
}

