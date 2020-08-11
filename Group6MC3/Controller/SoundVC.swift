//
//  SoundViewController.swift
//  Group6MC3
//
//  Created by Glendito Jeremiah Palendeng on 26/07/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//

import UIKit
import AVFoundation

class SoundVC: UIViewController {

    @IBOutlet weak var forestPlayOutlet: UIButton!
    @IBOutlet weak var rainPlayOutlet: UIButton!
    @IBOutlet weak var wavePlayOutlet: UIButton!
    @IBOutlet weak var firePlayOutlet: UIButton!
    @IBOutlet weak var thunderPlayOutlet: UIButton!
    @IBOutlet weak var windPlayOutlet: UIButton!
    
    var forestSound : AVAudioPlayer!
    var rainSound : AVAudioPlayer!
    var waveSound : AVAudioPlayer!
    var fireSound : AVAudioPlayer!
    var thunderSound : AVAudioPlayer!
    var windSound : AVAudioPlayer!
    
    @IBOutlet weak var forestView: UIImageView!
    @IBOutlet weak var rainView: UIImageView!
    @IBOutlet weak var waveView: UIImageView!
    @IBOutlet weak var fireView: UIImageView!
    @IBOutlet weak var thunderView: UIImageView!
    @IBOutlet weak var windView: UIImageView!
    
    var timer = Timer()
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setFireSound()
        setRainSound()
        setWaveSound()
        setWindSound()
        setThunderSound()
        setForestSound()
        
        forestView.addShadow()
        rainView.addShadow()
        windView.addShadow()
        fireView.addShadow()
        thunderView.addShadow()
        waveView.addShadow()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(update) , userInfo: nil, repeats: true)
        // Do any additional setup after loading the view.
    }
    
    @IBAction func forestPlayTapped(_ sender: Any) {
        if forestSound?.isPlaying == false{
            forestSound?.play()
            forestPlayOutlet.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        else if forestSound?.isPlaying == true{
            forestSound?.stop()
            forestSound?.currentTime = 0
            forestPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    @IBAction func rainPlayTapped(_ sender: Any) {
        if rainSound?.isPlaying == false{
            rainSound?.play()
            rainPlayOutlet.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        else if rainSound?.isPlaying == true{
            rainSound?.stop()
            rainSound?.currentTime = 0
            rainPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    @IBAction func wavePlayTapped(_ sender: Any) {
        if waveSound?.isPlaying == false{
            waveSound?.play()
            wavePlayOutlet.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        else if waveSound?.isPlaying == true{
            waveSound?.stop()
            waveSound?.currentTime = 0
            wavePlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    @IBAction func firePlayTapped(_ sender: Any) {
        if fireSound?.isPlaying == false{
            fireSound?.play()
            firePlayOutlet.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        else if fireSound?.isPlaying == true{
            fireSound?.stop()
            fireSound?.currentTime = 0
            firePlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    @IBAction func thunderPlayTapped(_ sender: Any) {
        if thunderSound?.isPlaying == false{
            thunderSound?.play()
            thunderPlayOutlet.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        else if thunderSound?.isPlaying == true{
            thunderSound?.stop()
            thunderSound?.currentTime = 0
            thunderPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    @IBAction func windPlayTapped(_ sender: Any) {
        if windSound?.isPlaying == false{
            windSound?.play()
            windPlayOutlet.setBackgroundImage(UIImage(systemName: "pause.circle"), for: .normal)
        }
        else if windSound?.isPlaying == true{
            windSound?.stop()
            windSound?.currentTime = 0
            windPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }
    
    func setForestSound(){
        let path = Bundle.main.path(forResource: "Nature_Forest.mp3", ofType:nil)!
        let url = URL(fileURLWithPath: path)
        do {
            forestSound = try AVAudioPlayer(contentsOf: url)
        } catch {
            print("couldn't load file")
        }
        forestSound?.numberOfLoops = 24
    }
    func setRainSound(){
           let path = Bundle.main.path(forResource: "City_Rain.mp3", ofType:nil)!
           let url = URL(fileURLWithPath: path)
           do {
               rainSound = try AVAudioPlayer(contentsOf: url)
           } catch {
               print("couldn't load file")
           }
        rainSound?.numberOfLoops = 12
       }
    func setWaveSound(){
           let path = Bundle.main.path(forResource: "ocean_waves.mp3", ofType:nil)!
           let url = URL(fileURLWithPath: path)
           do {
               waveSound = try AVAudioPlayer(contentsOf: url)
           } catch {
               print("couldn't load file")
           }
        waveSound.numberOfLoops = 25
       }
    func setFireSound(){
           let path = Bundle.main.path(forResource: "camp_fire.mp3", ofType:nil)!
           let url = URL(fileURLWithPath: path)
           do {
               fireSound = try AVAudioPlayer(contentsOf: url)
           } catch {
               print("couldn't load file")
           }
        fireSound?.numberOfLoops = 17
       }
    func setThunderSound(){
           let path = Bundle.main.path(forResource: "nature_rain_thunderstorm.mp3", ofType:nil)!
           let url = URL(fileURLWithPath: path)
           do {
               thunderSound = try AVAudioPlayer(contentsOf: url)
           } catch {
               print("couldn't load file")
           }
        thunderSound?.numberOfLoops = 33
       }
    func setWindSound(){
           let path = Bundle.main.path(forResource: "nature_wind.mp3", ofType:nil)!
           let url = URL(fileURLWithPath: path)
           do {
               windSound = try AVAudioPlayer(contentsOf: url)
           } catch {
               print("couldn't load file")
           }
        windSound?.numberOfLoops = 24
       }
    
    @objc func update(){
        if forestSound?.isPlaying == false {
            forestPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        else if rainSound?.isPlaying == false{
            rainPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        else if waveSound?.isPlaying == false{
            wavePlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        else if fireSound?.isPlaying == false{
            firePlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        else if thunderSound?.isPlaying == false{
            thunderPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
        else if windSound?.isPlaying == false{
            windPlayOutlet.setBackgroundImage(UIImage(systemName: "play.circle"), for: .normal)
        }
    }

}

extension UIView {

    func addShadow() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0, height: 0)
        layer.shadowOpacity = 1
        layer.shadowRadius = 5
        clipsToBounds = false
    }
}
