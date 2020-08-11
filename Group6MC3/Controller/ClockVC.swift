//
//  xClockVC.swift
//  Group6MC3
//
//  Created by Glendito Jeremiah Palendeng on 21/07/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//
import UIKit

class ClockVC: UIViewController {
    
    
    @IBOutlet weak var sleepScheduleOutlet: UIButton!
    @IBOutlet weak var clockLabel: UILabel!
    @IBOutlet weak var sleepButtonOutlet: UIButton!
    @IBOutlet weak var bigLabel: UILabel!
    @IBOutlet weak var smallLabel: UILabel!
    
    
    @IBOutlet weak var bedtimeLabel: UILabel!
    @IBOutlet weak var waketimeLabel: UILabel!
    
    let set = SetSchedule()
    var timer = Timer()
    var isOrange : Bool = false
    var bedRecieved : String = ""
    var wakeRecieved : String = ""
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setBedWakeLabel()
        sleepScheduleOutlet.layer.cornerRadius = 5
        sleepScheduleOutlet.layer.shadowRadius = 5
        sleepScheduleOutlet.layer.shadowOffset = CGSize(width: 0, height: 4)
        
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(updatePerSecond) , userInfo: nil, repeats: true)
        
    }
    
    func setBedWakeLabel(){
        if let setBed = set.defaults.string(forKey: "BedTime"){
            bedtimeLabel.text = setBed
        }
        if let setWake = set.defaults.string(forKey: "WakeTime"){
            waketimeLabel.text = setWake
        }
    }
    
    @IBAction func sleepButtonTapped(_ sender: Any) {
//        if isWake == true{
//            sleepButtonOutlet.setImage(#imageLiteral(resourceName: "Wake Button"), for: .normal)
//            clockLabel.textColor = UIColor.white
//            isWake = false
//            bigLabel.text = "Wake Up!"
//        }
//        else if isWake == false{
//            sleepButtonOutlet.setImage(#imageLiteral(resourceName: "Sleep Button"), for: .normal)
//            clockLabel.textColor = #colorLiteral(red: 1, green: 0.5444618464, blue: 0, alpha: 1)
//            isWake = true
//            bigLabel.text = "Sleep Time!"
//        }
        
        if isOrange == true{
            sleepButtonOutlet.setImage(#imageLiteral(resourceName: "Sleep Button"), for: .normal)
            clockLabel.textColor = #colorLiteral(red: 1, green: 0.5444618464, blue: 0, alpha: 1)
            isOrange = false
            bigLabel.text = "Sleep Time!"
            smallLabel.text = "Tap when you’re going to sleep"
        }
    }
    
    @IBAction func setSleepSchedule(_ sender: Any) {
        
    }
    
    @objc func updatePerSecond(){
        displayClock()
        checkTime()
        setWakeBedTime()
    }
    
    func checkTime(){
        if clockLabel.text == waketimeLabel.text{
            sleepButtonOutlet.setImage(#imageLiteral(resourceName: "Wake Button"), for: .normal)
            clockLabel.textColor = UIColor.white
            isOrange = true
            bigLabel.text = "Wake Up!"
            smallLabel.text = "Tap when you wake up"
        }
    }
    
    func displayClock(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        
        if hour < 10 && minute < 10{
            clockLabel.text = "0\(hour):0\(minute)"
        }
        else if hour < 10 {
            clockLabel.text = "0\(hour):\(minute)"
        }
        else if minute < 10{
            clockLabel.text = "\(hour):0\(minute)"
        }
        else{
            clockLabel.text = "\(hour):\(minute)"
        }
    }
    func setWakeBedTime(){
        if wakeRecieved != ""{
            waketimeLabel.text = wakeRecieved
            bedtimeLabel.text = bedRecieved
        }
    }
    
    @IBAction func unwindToHome (_ sender:UIStoryboardSegue){
        
    }
   
}
