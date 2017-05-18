//
//  ViewController.swift
//  EMSMotionTester
//
//  Created by Kerry Washington on 5/17/17.
//  Copyright © 2017 Ticketfly Inc. All rights reserved.
//

import UIKit
import CoreMotion

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
        
    }
    
    @IBAction func stopSensing(_ sender: Any) {
        
    }
    
    @IBAction func addValue(_ sender: Any) {
        
    }
    @IBAction func subtractValue(_ sender: Any) {
        
    }
    
    
    var motionManager: CMMotionManager!
    var timingInterval = 1.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupMotionManager()
        
        
    }
    
    func setupMotionManager() {
    
        timingIntervalSlider.value = Float(timingInterval)
    
    
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

