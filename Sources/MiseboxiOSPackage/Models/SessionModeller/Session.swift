//
//  File.swift
//  MiseboxiOSPackage
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Combine


extension SessionManager {
    
    public class Session: ObservableObject {
        public let role: UserRole = .miseboxUser
        @Published public var id = ""
        @Published public var isDarkMode = false
    }
}

