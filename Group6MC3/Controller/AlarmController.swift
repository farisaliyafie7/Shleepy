//
//  AlarmController.swift
//  Group6MC3
//
//  Created by Faris Ali Yafie on 23/07/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//

import UIKit

class AlarmController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource{
    
    var selectedSound: String?
    
    let soundList = ["Mute","Noise","Calm"]
    let repeatList = ["5", "10", "15", "20", "25", "30"]
    let typeList = ["Tone", "Tone + Vibrate", "Vibrate"]
    let pickerView = UIPickerView()
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return soundList.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return soundList[row]
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        selectedSound = soundList[row]
//        setting.editableSound.text = selectedSound
    }
    
    func createSoundPicker(){
        let pickerView = UIPickerView()
        pickerView.delegate = self
        
        
        //toolbar
        let toolbar = UIToolbar()
        toolbar.sizeToFit()

        //bar button
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneSoundTapped))
        let spaceButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonItem.SystemItem.flexibleSpace, target: nil, action: nil)
        toolbar.tintColor = UIColor(red: 255/255, green: 146/255, blue: 0/255, alpha: 1)
        toolbar.setItems([spaceButton, doneBtn], animated: true)
        toolbar.isUserInteractionEnabled = true
    }
    
    @objc func doneSoundTapped(){
        self.view.endEditing(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

}
