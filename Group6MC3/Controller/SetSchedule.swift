//
//  setSchedule.swift
//  Group6MC3
//
//  Created by Venus Dhammiko on 23/07/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//

import UIKit

class SetSchedule: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    @IBOutlet weak var ageGroupField: UITextField!
    @IBOutlet weak var sleepDurationField: UITextField!
    @IBOutlet weak var bedTimeField: UITextField!
    @IBOutlet weak var wakeTimeField: UITextField!
    
    let defaults = UserDefaults.standard
    
    var ageGroupArr = [" ","School Age Child (6-13 years old)","Teenager (14-17 years old)","Young Adult (18-25 years old)", "Adult (26 - 64 years old)", "Elderly (65+ years old)"]
    
    var pickerView = UIPickerView()
    var currentTextField = UITextField()
    
    var alert: UIAlertController!
    
    var timePicker = UIDatePicker()
    
    var ageGroup: String{
        get{
            return ageGroupField.text ?? ""
        }
        set{
            ageGroupField.text = newValue
        }
    }
    
    var bedTime: String{
        get {
            return bedTimeField.text ?? ""
        }
        set {
            bedTimeField.text = newValue
        }
    }
    
    var wakeTime: String{
        get {
            return wakeTimeField.text ?? ""
        }
        set {
            wakeTimeField.text = newValue
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        createTimePicker()
        createTimePicker2()
        
        setAgeDurationTimeTextField()
        sleepDurationChecker()
        
        ageGroupField.borderColor()
        sleepDurationField.borderColor()
        bedTimeField.borderColor()
        wakeTimeField.borderColor()
        
        sleepDurationField.isEnabled = false
        
        //ageGroupField.attributedPlaceholder = NSAttributedString(string: "Set Age Group", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        //sleepDurationField.attributedPlaceholder = NSAttributedString(string: "Recommendation Sleep Duration", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        //bedTimeField.attributedPlaceholder = NSAttributedString(string: "Set Bed Time", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        //wakeTimeField.attributedPlaceholder = NSAttributedString(string: "Set Wake Time", attributes:[NSAttributedString.Key.foregroundColor: UIColor.white])
        
        ageGroupField.delegate = self
    }
    
    func setAgeDurationTimeTextField(){
        if let setAge = defaults.string(forKey: "Age"){
            ageGroupField.text = setAge
        }
        if let setDuration = defaults.string(forKey: "Duration"){
            sleepDurationField.text = setDuration
        }
        if let setBed = defaults.string(forKey: "BedTime"){
            bedTimeField.text = setBed
        }
        if let setWake = defaults.string(forKey: "WakeTime"){
            wakeTimeField.text = setWake
        }
    }
    
    func sleepDurationChecker(){
        if ageGroupField.text == "School Age Child (6-13 years old)"{
            sleepDurationField.text = "9-11 hours"
            defaults.set(sleepDurationField.text, forKey: "Duration")
        }else if ageGroupField.text == "Teenager (14-17 years old)"{
            sleepDurationField.text = "8-10 hours"
            defaults.set(sleepDurationField.text, forKey: "Duration")
        }else if ageGroupField.text == "Young Adult (18-25 years old)"{
            sleepDurationField.text = "7-9 hours"
            defaults.set(sleepDurationField.text, forKey: "Duration")
        }else if ageGroupField.text == "Adult (26 - 64 years old)"{
            sleepDurationField.text = "7-9 hours"
            defaults.set(sleepDurationField.text, forKey: "Duration")
        }else if ageGroupField.text == "Elderly (65+ years old)"{
            sleepDurationField.text = "7-8 hours"
            defaults.set(sleepDurationField.text, forKey: "Duration")
        }else{
            sleepDurationField.text = ""
        }
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
          1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if currentTextField == ageGroupField{
            return ageGroupArr.count
        }else{
            return 0
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if currentTextField == ageGroupField{
            return ageGroupArr[row]
        }else{
            return ""
        }
    }
        
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if currentTextField == ageGroupField{
            ageGroupField.text = ageGroupArr[row]
            sleepDurationChecker()
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, attributedTitleForRow row: Int, forComponent component: Int) -> NSAttributedString? {
        return NSAttributedString(string: ageGroupArr[row], attributes: [NSAttributedString.Key.foregroundColor: UIColor.white])
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        pickerView.dataSource = self
        pickerView.delegate = self
        
        currentTextField = textField
    
        if textField == ageGroupField{
            ageGroupField.inputView = pickerView
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
         defaults.set(currentTextField.text, forKey: "Age")
         self.view.endEditing(true)
    }
    
    func createTimePicker() {
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.tintColor = UIColor(red: 255/255, green: 146/255, blue: 0/255, alpha: 1)
        toolbar.setItems([spaceButton, doneBtn], animated: true)
        toolbar.isUserInteractionEnabled = true

        //assign datepicker to texfield
        bedTimeField.inputView = timePicker

        //assign toolbar
        bedTimeField.inputAccessoryView = toolbar

        //date picker mode
        timePicker.datePickerMode = .time
        timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
        timePicker.backgroundColor = UIColor(red: 42/255, green: 36/255, blue: 57/255, alpha: 1)
        timePicker.setValue(UIColor.white, forKeyPath: "textColor")
    }

    @objc func donePressed(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let dateSelect = formatter.string(from: timePicker.date)
        bedTimeField.text = dateSelect
        defaults.set(bedTimeField.text, forKey: "BedTime")
        self.view.endEditing(true)
    }
    
    func createTimePicker2() {
           //toolbar
           let toolbar = UIToolbar()
           toolbar.sizeToFit()

           //bar button
           let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(donePressed2))
           let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
           toolbar.tintColor = UIColor(red: 255/255, green: 146/255, blue: 0/255, alpha: 1)
           toolbar.setItems([spaceButton, doneBtn], animated: true)
           toolbar.isUserInteractionEnabled = true

           //assign datepicker to texfield
           wakeTimeField.inputView = timePicker

           //assign toolbar
           wakeTimeField.inputAccessoryView = toolbar

           //date picker mode
           timePicker.datePickerMode = .time
           timePicker.locale = NSLocale(localeIdentifier: "en_GB") as Locale
           timePicker.backgroundColor = UIColor(red: 42/255, green: 36/255, blue: 57/255, alpha: 1)
           timePicker.setValue(UIColor.white, forKeyPath: "textColor")
       }

    @objc func donePressed2(){
        //formatter
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        let dateSelect = formatter.string(from: timePicker.date)
        wakeTimeField.text = dateSelect
        defaults.set(wakeTimeField.text, forKey: "WakeTime")
        self.view.endEditing(true)
    }
    
    func showAlert() {
        alert = UIAlertController(title: "Error", message: "Please complete the form", preferredStyle: .alert)
        let action = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(action)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func cancelBtn(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func setBtn(_ sender: Any) {
        if ageGroup == "" || bedTime == "" || wakeTime == "" {
            showAlert()
        }else{
          bedTimeField.text = bedTime
          wakeTimeField.text = wakeTime
          self.performSegue(withIdentifier: "unwindToHome", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ClockVC
        destVC.bedRecieved = bedTime
        destVC.wakeRecieved = wakeTime
    }
    
    //func buat di copas ke glen
    //@IBAction func unwindToHome (_ sender:UIStoryboardSegue){}
}

extension UITextField{
    func borderColor(){
        //self.layer.cornerRadius = 8.0
        self.layer.masksToBounds = true
        self.layer.borderColor = UIColor( red: 255/255, green: 146/255, blue:0/255, alpha: 1.0 ).cgColor
        self.layer.borderWidth = 0.25
    }
}

