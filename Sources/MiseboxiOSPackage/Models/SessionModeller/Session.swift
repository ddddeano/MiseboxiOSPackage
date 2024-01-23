//
//  File.swift
//  MiseboxiOSPackage
//
//  Created by Daniel Watson on 22.01.24.
//

import Foundation
import Combine


extension SessionManager {
    
    public enum UserRole: String {
        case recruiter = "recruiter"
        case chef = "chef"
    }
    public class Session: ObservableObject {
        public let role: UserRole
        @Published public var id = ""
        @Published public var isDarkMode = false
        
        public init(role: UserRole) {
            self.role = role
        }
    }
}

