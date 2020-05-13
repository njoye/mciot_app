//
//  ESenseManager.swift
//  mciot_app
//
//  Created by Timo Müller on 13.05.20.
//  Copyright © 2020 471. All rights reserved.
//

import Foundation

import CoreBluetooth

class ESenseManager {
        // Single shared instance of ESenseManager so that every thing is handled through this class
        static let shared = ESenseManager()

        // Private ensures that there can only be one instance which is the shared one
        private init(){
            
        }
}
