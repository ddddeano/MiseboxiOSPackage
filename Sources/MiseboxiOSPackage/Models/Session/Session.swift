//
//  File.swift
//  MiseboxiOSPackage
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Combine

public enum UserRole {
    case miseboxUser, chef
}


extension SessionManager {
    
    public class Session: ObservableObject {
        let role: UserRole
        @Published var id = ""
        @Published var isDarkMode = false
        
        public init(role: UserRole) {
            self.role = role
        }
    }
}

