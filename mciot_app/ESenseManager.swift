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
    private var centralManager: CBCentralManager!
    
    // Defines if bluetooth is turned on or not
    var isBluetoothOn: Bool!
    
    static let shared = ESenseManager()
    
    override init(){
        super.init()
        centralManager = CBCentralManager(delegate: self, queue: nil)
        
        // Initialize to false
        isBluetoothOn = (centralManager.state == .poweredOn)
    }
    
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("[INFO] Bluetooth State Changed")
        if central.state != .poweredOn {
            print("[INFO] Bluetooth is turned off!")
            isBluetoothOn = false
        } else {
            print("[INFO] Bluetooth is turned ON - Searching for devices now!")
            isBluetoothOn = true
            /*centralManager.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])*/
        }
    }
    
    
    
    
    
    
    
    
}
