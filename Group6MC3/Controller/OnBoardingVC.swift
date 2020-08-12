//
//  OnboardingVC.swift
//  Group6MC3
//
//  Created by Glendito Jeremiah Palendeng on 29/07/20.
//  Copyright © 2020 Faris Ali Yafie. All rights reserved.
//
import UIKit

class OnBoardingVC: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }
    
    @IBAction func getStarted(_ sender: Any) {
        Core.shared.setIsNotNewUser()
        
        let storyboard = UIStoryboard(name: "TabNav", bundle: nil)
        let mainVC = storyboard.instantiateViewController(withIdentifier: "tabnav") as! UITabBarController
        
        self.present(mainVC,animated: true,completion: nil)
        
    }
    
}
