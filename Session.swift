//
//  File.swift
//  MiseboxiOSPackage
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Combine

extension SessionManager {
    class Session: ObservableObject {
        let role: String
        @Published var id = ""
        @Published var isDarkMode = false
        
        init(role: String) {
            self.role = role
        }
    }
}

