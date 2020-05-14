//
//  ConnectionViewController.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.
//

import UIKit

import ESense

class ConnectionViewController: UIViewController {
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var manager:ESenseManager? = nil
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
        // Call the MyESenseManager so that it initializes with the app start
        print(MyESenseManager.shared.isBluetoothOn ?? false)
    }
    
    
    @IBAction func searchButtonPressed(_ sender: Any) {
        // Start searching for Bluetooth devices
        // Check if Bluetooth is turned on
        if(!MyESenseManager.shared.isBluetoothOn){
            // Present an alert to the user to show him that there is no way around this
            let alert = UIAlertController(title: "Error", message: "Please turn on Bluetooth to use this functionality", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else{
            // Start a spinner in the top right
            activityIndicator.startAnimating()
            
            // Also start searching for a device
            MyESenseManager.shared.startSearchingForDevice()
        }
        
        
    }
    
}

