//
//  CalibrationViewController.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.
//
import UIKit

class CalibrationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private let nameArray = ["Status", "X-Wert", "Y-Wert", "Z-Wert"]
    private let valueArray = ["Disconnected", "0", "0", "0"]
    
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        tableView.dataSource = self
        tableView.delegate = self
    }

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
}
