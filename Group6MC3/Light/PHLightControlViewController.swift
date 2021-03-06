/*******************************************************************************
 Copyright (C) 2017 Philips Lighting Holding B.V.
 All Rights Reserved.
 ********************************************************************************/

import UIKit
import Foundation

struct PHConstants {
    static let PHMaxHue = 65535
    static let PHMaxSat = 254
    static let PHMaxBri = 254
}

protocol PHLightControlViewControllerSegueCoordinator : SegueCoordinator {
    func lightControlViewController(_ controller:PHLightControlViewController, didGetBridgeDiscoveryResults results:[PHBridgeInfo])
    func lightControlViewControllerNeedsPushLinkScreen(_ controller:PHLightControlViewController, withCompletionBlock completion:@escaping PushLinkPresentingCompletionBlock)
}

class PHLightControlViewController: UIViewController, NavigationHelping {
    @IBOutlet weak var ipAddressLabel:UILabel?
    @IBOutlet weak var uniqueIdLabel:UILabel?
    @IBOutlet weak var lightOffLabel: UILabel!
    @IBOutlet weak var lightOnLabel: UILabel!
    @IBOutlet weak var brightSlider: UISlider!
    
    let clock = ClockVC()
    var timer = Timer()
    
    lazy var segueCoordinator: PHLightControlViewControllerSegueCoordinator = HueQuickStartAppSegueCoordinator()
    var selectedBridge:PHBridgeInfo?
    var isStartingUp:Bool = true
    
    var activityIndicator:ActivityDisplaying? {
        get {
            return self.navigationController as? ActivityDisplaying ?? nil
        }
    }
    var alertHandler:AlertPresenting? {
        get {
            return self.navigationController as? AlertPresenting ?? nil
        }
    }
    lazy var bridgeDiscoveryController = {
        return BridgeDiscoveryController(activityIndicator:self.activityIndicator, alertHandler:self.alertHandler, delegate:self)
    }()
    
    var bridgeController:PHBridgeController?
    
    @IBOutlet weak var lightView: UIView!
    @IBOutlet weak var onOffButton: UIButton!
    
    let lightState:PHSLightState = PHSLightState()
    let set = SetSchedule()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setOffOnLabel()
        lightState.on = true
        lightView.layer.cornerRadius = 10
        onOffButton.layer.cornerRadius = 10
        configureNavigation()
        
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(triggerLight) , userInfo: nil, repeats: true)
        
        bridgeController = PHBridgeController(bridgeInfo: self.lastConnectedBridge,
                                              activityIndicator: activityIndicator,
                                              alertHandler: alertHandler,
                                              pushLinkHandler: self,
                                              delegate: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setOffOnLabel()
        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector:#selector(triggerLight) , userInfo: nil, repeats: true)
        if let bridgeController = self.bridgeController {
            if self.isStartingUp {
                bridgeController.connect()
            }
        } else {
            self.discoverBridges()
        }
        
        self.isStartingUp = false
    }
    
    @objc func triggerLight(){
        let date = Date()
        let calendar = Calendar.current
        let hour = calendar.component(.hour, from: date)
        let minute = calendar.component(.minute, from: date)
        var temp = ""
        if hour < 10 && minute < 10{
            temp = "0\(hour):0\(minute)"
        }
        else if hour < 10 {
            temp = "0\(hour):\(minute)"
        }
        else if minute < 10{
            temp = "\(hour):0\(minute)"
        }
        else{
            temp = "\(hour):\(minute)"
        }
        
        if  temp == lightOffLabel.text{
            self.offColors()
        }
        if  temp == lightOnLabel.text{
            self.onColors()
        }
    }
    
    func setOffOnLabel(){
        if let setBed = set.defaults.string(forKey: "BedTime"){
            lightOffLabel.text = setBed
        }
        if let setWake = set.defaults.string(forKey: "WakeTime"){
            lightOnLabel.text = setWake
        }
    }
    
    func discoverBridges() {
        self.bridgeDiscoveryController.discoverBridges()
    }
    
    var lastConnectedBridge:PHBridgeInfo? {
        get {
            if let lastConnectedBridge:PHSKnownBridge = PHSKnownBridge.lastConnectedBridge {
                let bridge = PHBridgeInfo(ipAddress: lastConnectedBridge.ipAddress, uniqueId: lastConnectedBridge.uniqueId)
                
                return bridge
            }
            
            return nil;
        }
    }
    
    @IBAction func randomizeLightButtonAction() {
        self.randomizeColors()
    }
    @IBAction func onOffLightButtonAction(_ sender: UIButton) {
        self.onOffColors()
    }
    
    @IBAction func findNewBridgeButtonAction() {
        self.discoverBridges()
    }
    
    var brightValue:Float = 0
    @IBAction func brightnessSliderAction(_ sender: UISlider) {
        brightValue = sender.value
        self.brightnessSlider()
    }
    
    func showBridgeDiscoveryResults(results:[PHBridgeInfo]) {
        self.segueCoordinator.lightControlViewController(self, didGetBridgeDiscoveryResults: results)
    }
}

private typealias PHLightControlViewControllerSegueHandling = PHLightControlViewController
extension PHLightControlViewControllerSegueHandling {
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.segueCoordinator.coordinate(segue:segue, sender:sender)
    }
    
    @IBAction func unwindToCancelPushLink(segue:UIStoryboardSegue) {
        self.bridgeController?.disconnect()
    }
    
    @IBAction func unwindToReloadBridges(segue:UIStoryboardSegue) {
        self.discoverBridges()
    }
    
    @IBAction func unwindToSelectBridge(segue:UIStoryboardSegue) {
        guard let selectedBridge = self.selectedBridge else {
            return
        }
        
        self.bridgeController?.delegate = nil
        self.bridgeController?.disconnect()
        
        self.bridgeController = PHBridgeController(bridgeInfo: selectedBridge,
                                                   activityIndicator: activityIndicator,
                                                   alertHandler: alertHandler,
                                                   pushLinkHandler: self,
                                                   delegate: self)
        self.bridgeController?.connect()
    }
}

private typealias PHLightControlViewControllerPushLinkPresenting = PHLightControlViewController
extension PHLightControlViewControllerPushLinkPresenting : PushLinkPresenting {
    func presentPushLinkScreen(completion: @escaping (Bool) -> ()) {
        self.segueCoordinator.lightControlViewControllerNeedsPushLinkScreen(self, withCompletionBlock:completion)
    }
    
    func dismissPushLinkScreen() {
        self.dismiss(animated: true, completion: nil)
    }
}

private typealias PHLightControlViewControllerLightControls = PHLightControlViewController
extension PHLightControlViewControllerLightControls {
    // random light color
    func randomizeColors() {
        if let devices:[PHSDevice] = self.bridgeController?.bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
            for device in devices {
                if let lightPoint:PHSLightPoint = device as? PHSLightPoint {
                    let lightState:PHSLightState = self.lightStateWithRandomColors()
                    
                    lightPoint.update(lightState, allowedConnectionTypes: .local, completionHandler: { (responses, errors, returnCode) in
                        // ...
                    })
                }
            }
        }
    }
    
    func lightStateWithRandomColors() -> PHSLightState {
        lightState.on = true
        lightState.hue = Int(arc4random_uniform(UInt32(PHConstants.PHMaxHue))) as NSNumber
        lightState.saturation = Int(UInt32(PHConstants.PHMaxSat)) as NSNumber
        lightState.brightness = Int(UInt32(200)) as NSNumber
        brightSlider.value = 200
        
        return lightState
    }
    
    // on and off light
        func onOffColors() {
            if let devices:[PHSDevice] = self.bridgeController?.bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
                for device in devices {
                    if let lightPoint:PHSLightPoint = device as? PHSLightPoint {
                        let lightState:PHSLightState = self.lightStateWithOnOff()
                        
                        lightPoint.update(lightState, allowedConnectionTypes: .local, completionHandler: { (responses, errors, returnCode) in
                            // ...
                        })
                    }
                }
            }
        }
        
        func lightStateWithOnOff() -> PHSLightState {
            if lightState.on.boolValue{
                lightState.on = false
                brightSlider.value = 0
            }else{
                lightState.on = true
                brightSlider.value = 200
                lightState.hue = Int(UInt32(0)) as NSNumber
                lightState.saturation = Int(UInt32(0)) as NSNumber
                lightState.brightness = Int(UInt32(200)) as NSNumber
            }
            return lightState
        }
    
    // brightness slider
    func brightnessSlider(){
        if let devices:[PHSDevice] = self.bridgeController?.bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
            for device in devices {
                if let lightPoint:PHSLightPoint = device as? PHSLightPoint {
                    let lightState:PHSLightState = self.lightStateWithSlider()
                    
                    lightPoint.update(lightState, allowedConnectionTypes: .local, completionHandler: { (responses, errors, returnCode) in
                        // ...
                    })
                }
            }
        }
    }
    
    func lightStateWithSlider() -> PHSLightState {
        if self.brightValue == 0{
            lightState.on = false
        }else{
            lightState.on = true
            lightState.brightness = Int(UInt32(self.brightValue)) as NSNumber
        }
        
        return lightState
    }
    
    // on light
    func onColors() {
        if let devices:[PHSDevice] = self.bridgeController?.bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
            for device in devices {
                if let lightPoint:PHSLightPoint = device as? PHSLightPoint {
                    let lightState:PHSLightState = self.lightStateWithOn()
                    
                    lightPoint.update(lightState, allowedConnectionTypes: .local, completionHandler: { (responses, errors, returnCode) in
                        // ...
                    })
                }
            }
        }
    }
    
    func lightStateWithOn() -> PHSLightState {
        lightState.on = true
        brightSlider.value = 0
        lightState.hue = Int(UInt32(0)) as NSNumber
        lightState.saturation = Int(UInt32(0)) as NSNumber
        lightState.brightness = Int(UInt32(200)) as NSNumber
        return lightState
    }
    
    // off light
    func offColors() {
        if let devices:[PHSDevice] = self.bridgeController?.bridge.bridgeState.getDevicesOf(.light) as? [PHSDevice] {
            for device in devices {
                if let lightPoint:PHSLightPoint = device as? PHSLightPoint {
                    let lightState:PHSLightState = self.lightStateWithOff()
                    
                    lightPoint.update(lightState, allowedConnectionTypes: .local, completionHandler: { (responses, errors, returnCode) in
                        // ...
                    })
                }
            }
        }
    }
    
    func lightStateWithOff() -> PHSLightState {
        lightState.on = false
        return lightState
    }
}

private typealias PHLightControlViewControllerNavigable = PHLightControlViewController
extension PHLightControlViewControllerNavigable : NavigableController {
    var screenTitle: String {
        return NSLocalizedString("Philips Hue", comment:"Title navigation light control screen")
    }
    
    var backButtonHidden: Bool {
        return false
    }
    
    var navigationBarHidden: Bool {
        return false
    }
    
    var rightNavigationButton: UIBarButtonItem {
        return UIBarButtonItem(title: NSLocalizedString("Find bridge", comment:"Find bridge button in bar on light control screen"),
                               style: .plain,
                               target: self,
                               action: #selector(findNewBridgeButtonAction))
    }
}

typealias PHLightControlViewControllerBridgeControllerDelegate = PHLightControlViewController
extension PHLightControlViewControllerBridgeControllerDelegate : PHBridgeControllerDelegate {
    func connected() {
        self.ipAddressLabel!.text = self.bridgeController?.bridge.bridgeConfiguration.networkConfiguration.ipAddress
        self.uniqueIdLabel!.text = self.bridgeController?.bridge.identifier
    }
    
    func disconnected() {
        self.ipAddressLabel?.text = NSLocalizedString("Not connected", comment:"Not Connected");
        self.uniqueIdLabel?.text = NSLocalizedString("Not connected", comment:"Not Connected");
        
        self.bridgeController?.delegate = nil
        self.discoverBridges()
    }
}

typealias PHLightControlViewControllerBridgeDiscoveryControllerDelegate = PHLightControlViewController
extension PHLightControlViewControllerBridgeDiscoveryControllerDelegate : PHBridgeDiscoveryControllerDelegate {
    func discoveryController(_ discoveryController: BridgeDiscoveryController, didFindBridges bridges: [PHBridgeInfo]) {
        self.showBridgeDiscoveryResults(results: bridges)
    }
}
