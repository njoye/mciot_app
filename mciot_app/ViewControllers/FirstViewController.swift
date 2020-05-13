//
//  ViewController.swift
//  ParticleBluetoothiOS
//
//  Created by Jared Wolff on 8/9/19.
//  Copyright © 2019 Jared Wolff. All rights reserved.
//
import UIKit
import CoreBluetooth

class FirstViewController: UIViewController, CBPeripheralDelegate, CBCentralManagerDelegate {
 
    // Characteristics
    private var battChar: CBCharacteristic?
    
    // Properties
    private var centralManager: CBCentralManager!
    private var peripheral: CBPeripheral!
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("View loaded")
        // Do any additional setup after loading the view.
        centralManager = CBCentralManager(delegate: self, queue: .main)
    }

    // If we're powered on, start scanning
    func centralManagerDidUpdateState(_ central: CBCentralManager) {
        print("Central state update")
        if central.state != .poweredOn {
            print("Central is not powered on")
        } else {
            print("Starting to search for devices")
            centralManager.scanForPeripherals(withServices: [], options: [CBCentralManagerScanOptionAllowDuplicatesKey: true])
        }
    }

    // Handles the result of the scan
    func centralManager(_ central: CBCentralManager, didDiscover peripheral: CBPeripheral, advertisementData: [String : Any], rssi RSSI: NSNumber) {
        print("Discovered a device")
        print("Name: \(peripheral.name) - UUID: \(peripheral.identifier)")
        
        
        
        
        
        
        /*
        // We've found it so stop scan
        self.centralManager.stopScan()
        
        // Copy the peripheral instance
        self.peripheral = peripheral
        self.peripheral.delegate = self
        
        // Connect!
        self.centralManager.connect(self.peripheral, options: nil)
        */
    }
    
    // The handler if we do connect succesfully
    func centralManager(_ central: CBCentralManager, didConnect peripheral: CBPeripheral) {
        if peripheral == self.peripheral {
            print("Connected to device")
        }
    }
    
    func centralManager(_ central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: Error?) {
        if peripheral == self.peripheral {
            print("Disconnected")
        }
    }
    
    // Handles discovery event
    func peripheral(_ peripheral: CBPeripheral, didDiscoverServices error: Error?) {
        if let services = peripheral.services {
            print("Found services!")
            for service in services {
                print(service.uuid)
                // Check here if the service we want exists and then search for characteristics with
                // peripheral.discoverCharacteristcs
            }
        }
    }
    
    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateNotificationStateFor characteristic: CBCharacteristic,
                     error: Error?) {
        print("Enabling notify ", characteristic.uuid)
        
        if error != nil {
            print("Enable notify error")
        }
    }

    func peripheral(_ peripheral: CBPeripheral,
                     didUpdateValueFor characteristic: CBCharacteristic,
                     error: Error?) {
        if( characteristic == battChar ) {
            print("Battery:", characteristic.value![0])
            
             //batteryPercentLabel.text = "\(characteristic.value![0])%"
        }
    }
    
    // Handling discovery of characteristics
    func peripheral(_ peripheral: CBPeripheral, didDiscoverCharacteristicsFor service: CBService, error: Error?) {
        if let characteristics = service.characteristics {
            for characteristic in characteristics {
                
            }
        }
    }

}
