//
//  ViewController.swift
//  EMSMotionTester
//
//  Created by Kerry Washington on 5/17/17.
//  Copyright © 2017 Ticketfly Inc. All rights reserved.
//

import UIKit
import CoreMotion
import CSVImporter

class ViewController: UIViewController {

    //Motion
    @IBOutlet weak var motionPitchValue: UILabel!
    @IBOutlet weak var motionYawValue: UILabel!
    @IBOutlet weak var motionRollValue: UILabel!
    //Gyro
    @IBOutlet weak var alpha: UILabel!
    @IBOutlet weak var beta: UILabel!
    @IBOutlet weak var gamma: UILabel!
    //Device Acceleration
    @IBOutlet weak var deviceAccelX: UILabel!
    @IBOutlet weak var deviceAccelY: UILabel!
    @IBOutlet weak var deviceAccelZ: UILabel!
    //User Acceleration
    @IBOutlet weak var userAccelX: UILabel!
    @IBOutlet weak var userAccelY: UILabel!
    @IBOutlet weak var userAccelZ: UILabel!
    
    @IBOutlet weak var timingIntervalLabel: UILabel!
    
    @IBOutlet weak var timingIntervalSlider: UISlider!
    @IBOutlet weak var subtract: UIButton!
    @IBOutlet weak var add: UIButton!
    
    @IBAction func startSensing(_ sender: Any) {
        
        motionManager.startAccelerometerUpdates()
        motionManager.startGyroUpdates()
        motionManager.startDeviceMotionUpdates(to: OperationQueue.main, withHandler:{  deviceManager, error in
 
            if let motion = deviceManager?.attitude, let gyroData = deviceManager?.rotationRate, let deviceAccel = deviceManager?.gravity, let userAccel = deviceManager?.userAcceleration {
            //Attitude
            self.motionPitchValue.text = String.init(format: "%0.05f", arguments: [motion.pitch])
            self.motionYawValue.text = String.init(format: "%0.05f", arguments: [motion.yaw])
            self.motionRollValue.text = String.init(format: "%0.05f", arguments: [motion.roll])
 
            //Gyro
            self.alpha.text = String.init(format: "%0.05f", arguments: [gyroData.x])
            self.beta.text = String.init(format: "%0.05f", arguments: [gyroData.y])
            self.gamma.text = String.init(format: "%0.05f", arguments: [gyroData.z])
            //Device Acceleration
            self.deviceAccelX.text = String.init(format: "%0.05f", arguments: [deviceAccel.x])
            self.deviceAccelY.text = String.init(format: "%0.05f", arguments: [deviceAccel.y])
            self.deviceAccelZ.text = String.init(format: "%0.05f", arguments: [deviceAccel.z])
            //User Acceleration
            self.userAccelX.text = String.init(format: "%0.05f", arguments: [userAccel.x])
            self.userAccelY.text = String.init(format: "%0.05f", arguments: [userAccel.y])
            self.userAccelZ.text = String.init(format: "%0.05f", arguments: [userAccel.z])
                
            print(motion.pitch)
                
            }
        })
    
    }
    
    @IBAction func stopSensing(_ sender: Any) {
        
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
        
        for valueLabel in self.view.subviews {
        
            if let label = valueLabel as? UILabel {
            
                if label.tag == 75 {
                    label.text = "0.0000"
                }
            }
        }
    
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        
        timingIntervalLabel.text = String.init(format: "%0.2f", arguments: [sender.value]) + "  Sec."
    }
    
    
    @IBAction func addValue(_ sender: Any) {
        self.timingIntervalSlider.value += 0.01
        timingInterval = Double(self.timingIntervalSlider.value)
        timingIntervalLabel.text = String.init(format: "%0.2f", arguments: [timingInterval]) + "  Sec."
    }
    
    @IBAction func subtractValue(_ sender: Any) {
        self.timingIntervalSlider.value -= 0.01
        timingInterval = Double(self.timingIntervalSlider.value)
        timingIntervalLabel.text = String.init(format: "%0.2f", arguments: [timingInterval]) + "  Sec."

    }
    
    
    
    var motionManager: CMMotionManager!
    var timingInterval = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupMotionManager()
        setupCSVFile()
        
    }
    
    func setupMotionManager() {
    
        timingIntervalSlider.value = Float(timingInterval)
        timingIntervalLabel.text = String.init(format: "%0.2f", arguments: [timingInterval]) + "  Sec."
        
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = timingInterval
        motionManager.accelerometerUpdateInterval = timingInterval
        motionManager.gyroUpdateInterval = timingInterval
        
    
    }
    
    
    func setupCSVFile() {
        
        let path = ""
        //let importer = CSVImporter<[String]>(path:path)
        
    
        
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

