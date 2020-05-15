//
//  MyESenseManager.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth
import ESense
import AVFoundation

class MyESenseManager: NSObject, CBCentralManagerDelegate {
    
    // The one shared variable that every caller accesses
    // Typical pattern for Swift Apps :)
    static let shared = MyESenseManager()
    
    
    /* Bluetooth Connection Variables*/
    
    // The CoreBluetooth Manager, used to check if Bluetooth is turned on
    private var centralManager: CBCentralManager!
    
    // The eSenseManager from the Pod 'ESense' that handles the connection &
    // other stuff that comes from the Earphone
    private var esenseManager: ESenseManager? = nil
    
    // The configuriation variable for the ESense headphones, is written to the headphone
    // See BLE Specification for more details
    private var sensorConfig:ESenseConfig?
    
    
    
    /* *Variables used for calculating the angle* */
    
    // Holds the last values of the gyrosensor to check if it has dropped
    var lastGyroValues:[Double] = []
    
    // The gyro (deg/sec) sample value of the previous sample
    var prevSample: Double = 0.0
    
    // The gyro (deg/sec) sample value of the current sample
    var sample: Double = 0.0
    
    // The time "stamp" of the last sample (not actually representing date&time)
    var prevTime = CACurrentMediaTime()
    
    // The result of the angle calculation
    var current_angle:Double = 0.0
    
    // Total Head Rotation over 2 seconds
    var total_rotation:Double = 0.0
    
    
    /* Miscellaneous Variables*/
    
    // Stores whether Bluetooth is turned on or not
    var isBluetoothOn: Bool!
    
    // The audio player that plays the warning sound
    var player: AVAudioPlayer?
    
    
    /**
     Initializer for this class, initializes all uninitialized variables that are defined
     above this method.
     */
    private override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Initialize the ESenseManager
        esenseManager = ESenseManager(deviceName: "eSense-0219", listener: self)
        
        // Initialize to false
        isBluetoothOn = (centralManager.state == .poweredOn)
        
        // Also initialize the sensor config
        self.sensorConfig = ESenseConfig.init(accRange: .G_4, gyroRange: .DEG_250, accLPF: .BW_5, gyroLPF: .BW_5)
    }
    
    /**
     Fires whenever the state of the bluetooth value changes (on / off)
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        if central.state != .poweredOn {
            print("[INFO] Bluetooth is turned off")
            isBluetoothOn = false
        } else {
            print("[INFO] Bluetooth is turned on")
            isBluetoothOn = true
        }
    }
    
    
    /**
     Starts searching for the desired BLE Device, once it's found, the delegate methods will take over.
     */
    func startSearchingForDevice(){
        print("[INFO] Starting to search & connect to BLE Device")
        print("Connecting: \(String(describing: esenseManager?.connect(timeout: 10)))")
    }
    
    
    /**
     Returns the current connection value, because the "connected" handler fires too early sometimes, lel.
     */
    func isActuallyConnected() -> Bool{
        return (esenseManager?.isConnected())!
    }
    
    
    func startMeasurement(){
        // Set the sensor config
        if let config = self.sensorConfig{
            print("Setting Sensor Config -> \(String(describing: esenseManager?.setSensorConfig(config)))")
        }
        
        // Register the event listener
        print("RegisterEventListener: \(String(describing: esenseManager?.registerEventListener(self)))")
        
        // Register the sensor listener
        print("RegisterSensorListener: \(String(describing: esenseManager?.registerSensorListener(self, hz: 10)))")
    }
    
    func playWarningSound(){
        guard let url = Bundle.main.url(forResource: "warning_fx", withExtension: "mp3") else { return }
        
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
            
            player = try AVAudioPlayer(contentsOf: url, fileTypeHint: AVFileType.mp3.rawValue)
            
            guard let player = player else { return }
            
            player.play()
        } catch let error {
            print(error.localizedDescription)
        }
    }
}

/**
 The extension that uses the ESense Pod to connect to the Headphones
 */
extension MyESenseManager:ESenseConnectionListener{
    func onDeviceFound(_ manager: ESenseManager) {
        NotificationCenter.default.post(Notification(name: Notification.Name("FoundDevice")))
        print("[INFO] Found Device")
    }
    
    func onDeviceNotFound(_ manager: ESenseManager) {
        NotificationCenter.default.post(Notification(name: Notification.Name("DidntFindDevice")))
        print("[INFO] Did not find device")
    }
    
    func onConnected(_ manager: ESenseManager) {
        NotificationCenter.default.post(Notification(name: Notification.Name("Connected")))
        print("[INFO] Connected to device")
    }
    
    func onDisconnected(_ manager: ESenseManager) {
        NotificationCenter.default.post(Notification(name: Notification.Name("Disconnected")))
        print("[INFO] Disconnected from device")
    }
}





// MARK: - Angle measurement / Sensor Listener
extension MyESenseManager:ESenseSensorListener{
    
    /**
     Fires whenever there is a sensor change (currently set to 10hz, so every 10th of a second).
     This method converts the gyroscope values to degree/second calculates a delta value for the angle
     (it calculates the angle difference between the current and the last sample). After saving (currently) 20 of these
     (so 2 seconds) the total distance travelled is summed up and if there is a bigger difference than 17 deg travelled,
     a warning sound is played.
     */
    func onSensorChanged(_ evt: ESenseEvent) {
        //print("Sensor change :) \(evt)")
        let gyroValues = evt.convertGyroToDegPerSecond(config: self.sensorConfig!)
        
        // get the current time (not actually the time, just seconds representation
        let current_time = CACurrentMediaTime()
        
        // calculate the time difference between the previous sample and the current one
        let delta_time = current_time - prevTime
        
        // Set the previous time to the current one so that the correct
        // Time is used later on
        prevTime = current_time
        
        // Calculate delta_angle
        let delta_angle = gyroValues[2] * delta_time
        
        // angles smaller than abs(2) are likely to be just noise, so cut them out
        if delta_angle > 2 || delta_angle < -2 {
            current_angle += delta_angle
        }
        
        if lastGyroValues.count >= 20 {
            // If there is 20 values (2 seconds) -> add the gyrovalues together and check if the
            var total:Double = 0
            for deltaAngle in lastGyroValues{
                total += deltaAngle
            }
            
            // Set the total rotation
            self.total_rotation = total
            // Notify the table view so that it can retrieve this value
            NotificationCenter.default.post(Notification(name: Notification.Name("NewRotationValue")))
            
            
            
            // Figured this value out mostly through trial and error, works well for walking though
            if total >= 17 {
                // Notify the user through the headphone to keep his head straight
                playWarningSound()
            }
            
            // Also, reset the values
            lastGyroValues = []
        }else{
            // Just add the current delta_angle
            if delta_angle > 2 || delta_angle < -2{
                lastGyroValues.append(delta_angle)
            }else{
                lastGyroValues.append(0.0)
            }
        }
    }
}



/**
    The event listeners that get called whenever getBatteryVoltage, etc. are executed.
 */
extension MyESenseManager:ESenseEventListener{
    func onBatteryRead(_ voltage: Double) {
        print("Battery Voltage: \(voltage)")
    }
    
    func onButtonEventChanged(_ pressed: Bool) {
        print("Button value has changed, pressed = \(pressed)")
    }
    
    func onAdvertisementAndConnectionIntervalRead(_ minAdvertisementInterval: Int, _ maxAdvertisementInterval: Int, _ minConnectionInterval: Int, _ maxConnectionInterval: Int) {
        // Leave empty :)
    }
    
    func onDeviceNameRead(_ deviceName: String) {
        print("Got the device name: \(deviceName)")
    }
    
    func onSensorConfigRead(_ config: ESenseConfig) {
        print("Sensor config read")
    }
    
    func onAccelerometerOffsetRead(_ offsetX: Int, _ offsetY: Int, _ offsetZ: Int) {
        print("accelerometer offset read")
    }
}
