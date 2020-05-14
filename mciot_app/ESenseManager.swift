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


class MyESenseManager: NSObject, CBCentralManagerDelegate {
    
    // The one shared variable that every caller accesses
    // Typical pattern for Swift Apps :)
    static let shared = MyESenseManager()
    
    // The CoreBluetooth Manager that handles the connections
    private var centralManager: CBCentralManager!
    private var esenseManager: ESenseManager? = nil
    
    
    // Defines if bluetooth is turned on or not
    var isBluetoothOn: Bool!

    
    /**
        Initializer for this class, initializes all uninitialized variables that are defined
        above this method.
     */
    private override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Initialize the ESenseManager
        esenseManager = ESenseManager(deviceName: "eSense-1765", listener: self)
        
        // Use this class as sensor listener
        esenseManager?.registerSensorListener(self, hz: 10)
        
        // Use this class as event listener
        
        
        // Initialize to false
        isBluetoothOn = (centralManager.state == .poweredOn)
    }
    
    
    
    
    /**
     Fires whenever the state of the bluetooth value changes (on / off)
     */
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("[INFO] Bluetooth State Changed")
        if central.state != .poweredOn {
            print("[INFO] Bluetooth is turned off!")
            isBluetoothOn = false
        } else {
            print("[INFO] Bluetooth is turned ON - Searching for devices now!")
            isBluetoothOn = true
         }
    }
    
    
    /**
     Starts searching for the desired BLE Device, once it's found, the delegate methods will take over.
     */
    func startSearchingForDevice(){
        print("[INFO] Starting to search & connect to BLE Device")
        print("Connecting: \(esenseManager?.connect(timeout: 10))")
        
        //TODO: add services to look for :)
        //centralManager.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
}

/**
 The extension that uses the ESense Pod to connect to the Headphones
 */
extension MyESenseManager:ESenseConnectionListener{
    func onDeviceFound(_ manager: ESenseManager) {
        print("Found device")
    }
    
    func onDeviceNotFound(_ manager: ESenseManager) {
        print("Not found device")
    }
    
    func onConnected(_ manager: ESenseManager) {
        print("connected")
    }
    
    func onDisconnected(_ manager: ESenseManager) {
        print("disconnected")
    }
}

extension MyESenseManager:ESenseSensorListener{
    func onSensorChanged(_ evt: ESenseEvent) {
        print("Sensor change :) \(evt)")
    }
}

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
