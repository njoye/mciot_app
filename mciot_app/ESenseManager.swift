//
//  ESenseManager.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.
//

import Foundation
import UIKit
import CoreBluetooth

class ESenseManager: NSObject, CBCentralManagerDelegate {
    
    // The one shared variable that every caller accesses
    // Typical pattern for Swift Apps :)
    static let shared = ESenseManager()
    
    // The CoreBluetooth Manager that handles the connections
    private var centralManager: CBCentralManager!
    
    // Defines if bluetooth is turned on or not
    var isBluetoothOn: Bool!

    
    /**
        Initializer for this class, initializes all uninitialized variables that are defined
        above this method.
     */
    private override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
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
        print("[INFO] Starting to search for BLE Device")
        
        //TODO: add services to look for :)
        centralManager.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
    }
}
