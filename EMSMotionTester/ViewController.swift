//
//  ViewController.swift
//  EMSMotionTester
//
//  Created by Kerry Washington on 5/17/17.
//  Copyright © 2017 Ticketfly Inc. All rights reserved.
//

import UIKit
import CoreMotion
import MessageUI

class ViewController: UIViewController,MFMailComposeViewControllerDelegate {

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
    
    @IBOutlet weak var startButton: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    
    var motionManager: CMMotionManager!
    var timingInterval = 0.2
    var csvFileName = ""
    let headerText = "Timestamp,Pitch,Roll,Yaw,Alpha,Beta,Gamma,Device Acceleration (X),Device Acceleration (Y),Device Acceleration (Z),User Acceleration (X),User Acceleration (Y),User Acceleration (Z)\n"
    var newLine = ""
    var isCollectingData = false
    
    @IBAction func startSensing(_ sender: Any) {
        newLine = headerText
        isCollectingData = true
        startButton.isEnabled = false
        motionManager = CMMotionManager()
        motionManager.deviceMotionUpdateInterval = timingInterval
        motionManager.accelerometerUpdateInterval = timingInterval
        motionManager.gyroUpdateInterval = timingInterval
        
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
                
                let newData = "\(Date.init()),\(motion.pitch),\(motion.roll),\(motion.yaw),\(gyroData.x),\(gyroData.y),\(gyroData.z),\(deviceAccel.x),\(deviceAccel.y),\(deviceAccel.z),\(userAccel.x),\(userAccel.y),\(userAccel.z)\n"
                self.newLine.append(newData)
            }
        })
        stopButton.isEnabled = true
    }
    
    @IBAction func stopSensing(_ sender: Any) {
        isCollectingData = false
        stopButton.isEnabled = false
        motionManager.stopAccelerometerUpdates()
        motionManager.stopGyroUpdates()
        motionManager.stopDeviceMotionUpdates()
        motionManager = nil
        
        self.writeCSVFile(newline:self.newLine)
        self.newLine = ""
        startButton.isEnabled = true
    }
    
    @IBAction func sliderChanged(_ sender: UISlider) {
        timingInterval = Double(self.timingIntervalSlider.value)
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


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        setupMotionManager()
        UIDevice.current.beginGeneratingDeviceOrientationNotifications()
        //NotificationCenter.default().addObserver(self, selector: "orientationChanged:", name: UIDeviceOrientationDidChangeNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(orientationChanged), name: NSNotification.Name.UIDeviceOrientationDidChange, object: nil)
 
    }
    
    func setupMotionManager() {
        
        for valueLabel in self.view.subviews {
            
            if valueLabel is UILabel && valueLabel.tag == 75 {
                let v = valueLabel as! UILabel
                v.text = "0.0000"
            }
        }
        
        timingIntervalSlider.value = Float(timingInterval)
        timingIntervalLabel.text = String.init(format: "%0.2f", arguments: [timingInterval]) + "  Sec."

        
    
    }
    
    
    func writeCSVFile(newline:String) {
        self.clearTempFolder()
        self.csvFileName = "motion_readings_\(Date.init()).csv"
        let path = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(csvFileName)
        do {
            try self.newLine.write(to: path, atomically: true, encoding: String.Encoding.utf8)
            self.mailCSV()
        } catch {
            print("Failed to create file")
            print("\(error)")
        }
        
    }
    
    func clearTempFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    //MessagesUI
    func mailCSV() {
        let mailComposeViewController = configuredMailComposeViewController()
        if MFMailComposeViewController.canSendMail() {
            self.present(mailComposeViewController, animated: true, completion: nil)
        } else {
            self.showSendMailErrorAlert()
        }
    }
    
    func configuredMailComposeViewController() -> MFMailComposeViewController {

        let mailComposerVC = MFMailComposeViewController()
        mailComposerVC.mailComposeDelegate = self
        mailComposerVC.setToRecipients(["ems-mdm-scanner@ticketfly.com"])
        mailComposerVC.setSubject(" Data from motion \(self.csvFileName)")
        
        let path = NSURL.fileURL(withPath: NSTemporaryDirectory()).appendingPathComponent(csvFileName)
            if let fileData = NSData(contentsOf: path) {
                mailComposerVC.addAttachmentData(fileData as Data, mimeType:"text/csv", fileName:self.csvFileName)
            }
        
        return mailComposerVC
    }
    
    func showSendMailErrorAlert() {
        let sendMailErrorAlert = UIAlertView(title: "Could Not Send Email", message: "Your device could not send e-mail.  Please check e-mail configuration and try again.", delegate: self, cancelButtonTitle: "OK")
        sendMailErrorAlert.show()
    }
    
    // MARK: MFMailComposeViewControllerDelegate Method
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
        
 
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func orientationChanged(notification:Notification) {
    let info = notification.userInfo
        
        let or = UIDevice.current.orientation.hashValue
        print(or)
     
    }


}

