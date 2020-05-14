//
//  CalibrationViewController.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.
//
import UIKit

class CalibrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let nameArray = ["Search Status", "Connection Status", "X-Wert", "Y-Wert", "Z-Wert"]
    private var valueArray = ["Not searched yet", "Disconnected", "0", "0", "0"]
    
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Set Up the TableView
        tableView.dataSource = self
        tableView.delegate = self
        
        
        // Get Notifications for when the device has been connected
        NotificationCenter.default.addObserver(self, selector: #selector(onConnected), name: Notification.Name("Connected"), object: nil)
        
        // Get Notifications for when the device has not been connected
        NotificationCenter.default.addObserver(self, selector: #selector(onDisconnected), name: Notification.Name("Disconnected"), object: nil)
        
        // Get Notifications for when the device has been found
        NotificationCenter.default.addObserver(self, selector: #selector(onFoundDevice), name: Notification.Name("FoundDevice"), object: nil)
        
        // Get Notifications for when the device has not been found
        NotificationCenter.default.addObserver(self, selector: #selector(onNotFoundDevice), name: Notification.Name("DidntFindDevice"), object: nil)
        
    }

    @IBAction func connectButtonPressed(_ sender: Any) {
        if(MyESenseManager.shared.isBluetoothOn){
            // Turn on acitivity indicator
            activityIndicator.startAnimating()
            
            // Set value in info box
            valueArray[0] = "Searching ..."
            
            // Reload the table
            self.refreshTableView()
            
            // Start searching
            MyESenseManager.shared.startSearchingForDevice()
        }else{
            // Alert the user that Bluetooth is turned off
            let alert = UIAlertController(title: "Error", message: "Please turn on Bluetooth to use this functionality", preferredStyle: UIAlertController.Style.alert)
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Notification Handlers
    @objc func onConnected(){
        // Set status to connected
        valueArray[1] = "Connected"
        // Stop the activity indicator
        activityIndicator.stopAnimating()
        // Refresh the table
        self.refreshTableView()
    }
    
    @objc func onDisconnected(){
        // Set status to disconnected
        valueArray[1] = "Disconnected"
        self.refreshTableView()
    }
    
    @objc func onFoundDevice(){
        // Set search status to found
        valueArray[0] = "Found Device"
        // Stop the activity indicator
        activityIndicator.stopAnimating()
        // Refresh the table
        self.refreshTableView()
    }
    
    @objc func onNotFoundDevice(){
        // Set status to not found
        valueArray[0] = "Didn't find Device"
        self.refreshTableView()
    }
    
    
    
    // MARK: - Table View Functions
    /**
     Fires whenever a row has been selected, in our case, we don't want that :)
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }

    /**
     Returns the amount of cells that should be displayed in each section
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return valueArray.count
    }

    /**
    Returns the actual cell for a given index
     */
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // Get the cell
        let cell = tableView.dequeueReusableCell(withIdentifier: "InfoCell", for: indexPath as IndexPath) as! InfoTableViewCell
        
        // Configure the cell with name and value
        cell.nameLabel.text = nameArray[indexPath.row]
        cell.valueLabel.text = valueArray[indexPath.row]
        
        // Return the cell :)
        return cell
    }
    
    
    // MARK: - Helper Functions
    func refreshTableView(){
        tableView.reloadData()
    }
}
