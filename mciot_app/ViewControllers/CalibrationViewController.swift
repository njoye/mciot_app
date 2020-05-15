//
//  CalibrationViewController.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.
//
import UIKit
import AVFoundation


class CalibrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    /* Variables for the values of the table cells */
    private let nameArray = ["Search Status", "Connection Status", "Head Rotation"]
    private var valueArray = ["Not Searching", "Disconnected", "N/A"]
    
    /* Variables for UI Elements */
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var startButton: UIBarButtonItem!
    @IBOutlet weak var connectButton: UIBarButtonItem!
    @IBOutlet weak var tableView: UITableView!
    
    /**
     viewDidLoad is called as soon as the view has loaded, this is for the initial setup of the view
     */
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set Up the TableView
        tableView.dataSource = self
        tableView.delegate = self
        
        //TODO: make this prettier
        print("\(MyESenseManager.shared.isBluetoothOn)")
        
        
        // Get Notifications for when the device has been connected
        NotificationCenter.default.addObserver(self, selector: #selector(onConnected), name: Notification.Name("Connected"), object: nil)
        
        // Get Notifications for when the device has not been connected
        NotificationCenter.default.addObserver(self, selector: #selector(onDisconnected), name: Notification.Name("Disconnected"), object: nil)
        
        // Get Notifications for when the device has been found
        NotificationCenter.default.addObserver(self, selector: #selector(onFoundDevice), name: Notification.Name("FoundDevice"), object: nil)
        
        // Get Notifications for when the device has not been found
        NotificationCenter.default.addObserver(self, selector: #selector(onNotFoundDevice), name: Notification.Name("DidntFindDevice"), object: nil)
        
        // Get Notifications for when a new rotational value is accessible
        NotificationCenter.default.addObserver(self, selector: #selector(newRotationalValueAccessible), name: Notification.Name("NewRotationValue"), object: nil)
    }
    
    
    @IBAction func startButtonPressed(_ sender: Any) {
        // Start the measurement of angles
        MyESenseManager.shared.startMeasurement()
        
        // Start the activity indicator, because stuff has to be registered
        // It should be stopped as soon as the first measurement value has been received
        // That would be after about 2 seconds
        activityIndicator.startAnimating()
        
        
        //TODO: Disable the Button / Change it to stop the measurement
        
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
            /* Alert User that Bluetooth is turned off */
            
            // Create alert controller
            let alert = UIAlertController(title: "Error", message: "Please turn on Bluetooth to use this functionality", preferredStyle: UIAlertController.Style.alert)
            
            // Create the OK button
            alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
            
            // Actually show the alert
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    
    // MARK: - Notification Handlers
    @objc func onConnected(){
        // Set status to connected
        valueArray[1] = "Connected"
        
        // Stop the activity indicator now only, because inbefore there was
        // still work to do
        activityIndicator.stopAnimating()
        
        // Disable the connect button & enable the calibrate button
        startButton.isEnabled = true
        connectButton.isEnabled = false
        
        // Refresh the table
        self.refreshTableView()
    }
    
    @objc func onDisconnected(){
        // Set status to disconnected
        valueArray[1] = "Disconnected"
        
        // Refresh the table view
        self.refreshTableView()
    }
    
    @objc func onFoundDevice(){
        // Set search status to found
        valueArray[0] = "Found Device"
        
        // Refresh the table
        self.refreshTableView()
    }
    
    @objc func onNotFoundDevice(){
        // Set status to not found
        valueArray[0] = "Device not found"
        
        // Refresh the table view
        self.refreshTableView()
        
        /* Alert User that device has not been found */
        // Create alert controller
        let alert = UIAlertController(title: "Device not found", message: "Please make sure that the device is turned on & that it is close to the phone", preferredStyle: UIAlertController.Style.alert)
        
        // Create the OK button
        alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
        
        // Actually show the alert
        self.present(alert, animated: true, completion: nil)
    }
    
    @objc func newRotationalValueAccessible(){
        // Set the new value
        valueArray[2] = "~ \(MyESenseManager.shared.total_rotation.rounded()) °"
        
        // Stop the activityIndicator if it is still animating (only on first call)
        activityIndicator.stopAnimating()
        
        // Refresh the table view
        self.refreshTableView()
    }
    
    
    
    
    
    // MARK: - Table View Methods
    /**
     Fires whenever a row has been selected, in our case, we don't want that :)
     */
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        // Empty, because we don't want row selection to be possible
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
