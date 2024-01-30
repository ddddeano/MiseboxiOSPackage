//
//  File.swift
//  
//
//  Created by Daniel Watson on 30.01.24.
//

import Foundation

let defaultImage = "https://firebasestorage.googleapis.com/v0/b/misebox-78f9c.appspot.com/o/avatars%2Fdog1.jpg?alt=media&token=a8d8e14e-01af-45ae-8e9d-2033c5a81ec4"

protocol ManagerDelegate: AnyObject {
    func resetData()
}
